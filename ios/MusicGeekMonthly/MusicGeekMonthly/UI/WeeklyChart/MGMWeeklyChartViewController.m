
#import "MGMWeeklyChartViewController.h"

#import "MGMAlbumViewUtilities.h"
#import "MGMCoreDataTableViewDataSource.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"
#import "MGMTimePeriod.h"
#import "MGMWeeklyChartModalView.h"
#import "MGMWeeklyChartView.h"

@interface MGMWeeklyChartViewController () <MGMAlbumGridViewDelegate, UITableViewDelegate, MGMWeeklyChartViewDelegate, MGMWeeklyChartModalViewDelegate>

@property (strong) MGMWeeklyChartModalView* modalView;
@property (strong) MGMCoreDataTableViewDataSource* dataSource;
@property (strong) NSManagedObjectID* weeklyChartMoid;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMWeeklyChartViewController

#define CELL_ID @"MGMWeeklyChartViewControllerCellId"

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}

- (void) loadView
{
    MGMWeeklyChartView* weeklyChartView = [[MGMWeeklyChartView alloc] initWithFrame:[self fullscreenRect]];
    weeklyChartView.delegate = self;
    weeklyChartView.albumGridView.delegate = self;

    self.dataSource = [[MGMCoreDataTableViewDataSource alloc] initWithCellId:CELL_ID];
    self.dataSource.fetchedResultsController = [self.core.coreDataAccess createTimePeriodsFetchedResultsController];

    self.modalView = [[MGMWeeklyChartModalView alloc] initWithFrame:[self fullscreenRect]];
    self.modalView.delegate = self;
    self.modalView.timePeriodTable.dataSource = self.dataSource;
    self.modalView.timePeriodTable.delegate = self;

    self.view = weeklyChartView;
}

- (void) viewDidLoad
{
    MGMWeeklyChartView* weeklyChartView = (MGMWeeklyChartView*)self.view;

    NSUInteger albumCount = 25;
    [weeklyChartView.albumGridView setAlbumCount:albumCount detailViewShowing:YES];
    NSUInteger rowCount = self.ipad ? 4 : 2;
    NSUInteger columnCount = (albumCount + 3) / rowCount;
    CGFloat albumSize = weeklyChartView.albumGridView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [weeklyChartView.albumGridView setAlbumFrame:frame forRank:i + 1];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    NSError* error = nil;
    [self.dataSource.fetchedResultsController performFetch:&error];
    if (error != nil)
    {
        [self showError:error];
    }

    [self.modalView.timePeriodTable reloadData];

    if (self.weeklyChartMoid == nil && self.dataSource.fetchedResultsController.fetchedObjects.count > 0)
    {
        // Auto-populate for 1st entry...
        NSIndexPath* firstItem = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.modalView.timePeriodTable selectRowAtIndexPath:firstItem animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.modalView.timePeriodTable didSelectRowAtIndexPath:firstItem];
    }
}

- (void) loadAlbumsForPeriod:(MGMTimePeriod*)timePeriod
{
    MGMWeeklyChartView* weeklyChartView = (MGMWeeklyChartView*)self.view;

    [weeklyChartView setTitle:timePeriod.groupValue];

    dispatch_async(dispatch_get_main_queue(), ^{
        [weeklyChartView.albumGridView setActivityInProgressForAllRanks:YES];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MGMDaoData* data = [self.core.dao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate];
        NSError* fetchError = data.error;
        MGMWeeklyChart* weeklyChart = data.data;
        if (fetchError && weeklyChart)
        {
            [self logError:fetchError];
        }

        if (weeklyChart)
        {
            self.weeklyChartMoid = weeklyChart.objectID;
            [self reloadData];
        }
        else
        {
            [self showError:fetchError];
        }
    });
}

- (void) reloadData
{
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess threadVersion:self.weeklyChartMoid];
    for (MGMChartEntry* entry in weeklyChart.chartEntries)
    {
        MGMAlbum* album = entry.album;
        NSError* refreshError = nil;
        [self.core.albumRenderService refreshAlbumImages:album error:&refreshError];
        if (refreshError)
        {
            [self logError:refreshError];
        }
        [self renderChartEntry:entry];
    }
}

- (void) renderChartEntry:(MGMChartEntry*)chartEntry
{
    MGMWeeklyChartView* weeklyChartView = (MGMWeeklyChartView*)self.view;

    NSUInteger rank = chartEntry.rank.intValue;
    NSUInteger listeners = chartEntry.listeners.intValue;

    MGMAlbumView* albumView = [weeklyChartView.albumGridView albumViewForRank:rank];
    NSError* error = nil;
    [self.ui.viewUtilities displayAlbum:chartEntry.album inAlbumView:albumView rank:rank listeners:listeners error:&error];
    if (error)
    {
        [self.ui logError:error];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self dismissModalPresentation];
    MGMTimePeriod* timePeriod = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    [self loadAlbumsForPeriod:timePeriod];
}

#pragma mark -
#pragma mark MGMAlbumGridViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess threadVersion:self.weeklyChartMoid];
    MGMChartEntry* entry = [weeklyChart.chartEntries objectAtIndex:rank - 1];
    [self.albumSelectionDelegate albumSelected:entry.album];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess threadVersion:self.weeklyChartMoid];
    MGMChartEntry* entry = [weeklyChart.chartEntries objectAtIndex:rank - 1];
    [self.albumSelectionDelegate detailSelected:entry.album sender:self];
}

#pragma mark -
#pragma mark MGMWeeklyChartViewDelegate

- (void) moreButtonPressed:(id)sender
{
    if ([self isPresentingModally])
    {
        [self dismissModalPresentation];
    }
    else
    {
        [self presentViewModally:self.modalView sender:sender];
    }
}

#pragma mark -
#pragma mark MGMWeeklyChartModalViewDelegate

- (void) cancelButtonPressed:(id)sender
{
    [self moreButtonPressed:sender];
}

@end
