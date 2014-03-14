
#import "MGMWeeklyChartViewController.h"

#import "MGMChartEntry.h"
#import "MGMCoreDataTableViewDataSource.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"
#import "MGMTimePeriod.h"
#import "MGMWeeklyChart.h"
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
    CGFloat albumSize = weeklyChartView.albumGridView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRowSize:rowCount defaultRectSize:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [weeklyChartView.albumGridView setAlbumFrame:frame forRank:i + 1];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.core.dao fetchAllTimePeriods:^(MGMDaoData* timePeriodData) {
        if (timePeriodData.error)
        {
            [self showError:timePeriodData.error];
        }
        else
        {
            NSArray* moids = timePeriodData.data;
            NSArray* renderables = [self.core.coreDataAccess mainThreadVersions:moids];
            [self.dataSource setRenderables:renderables];
            
            [self.modalView.timePeriodTable reloadData];
            
            if (self.weeklyChartMoid == nil && renderables.count > 0)
            {
                // Auto-populate for 1st entry...
                NSIndexPath* firstItem = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.modalView.timePeriodTable selectRowAtIndexPath:firstItem animated:YES scrollPosition:UITableViewScrollPositionTop];
                [self tableView:self.modalView.timePeriodTable didSelectRowAtIndexPath:firstItem];
            }
        }
    }];
}

- (void) loadAlbumsForPeriod:(MGMTimePeriod*)timePeriod
{
    MGMWeeklyChartView* weeklyChartView = (MGMWeeklyChartView*)self.view;

    [weeklyChartView setTitle:timePeriod.groupValue];
    [weeklyChartView.albumGridView setActivityInProgressForAllRanks:YES];

    [self.core.dao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMDaoData* weeklyChartData) {
        NSError* fetchError = weeklyChartData.error;
        NSManagedObjectID* moid = weeklyChartData.data;
        if (fetchError && moid)
        {
            [self logError:fetchError];
        }
        
        if (moid)
        {
            self.weeklyChartMoid = moid;
            [self reloadData];
        }
        else
        {
            [self showError:fetchError];
        }
    }];
}

- (void) reloadData
{
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess mainThreadVersion:self.weeklyChartMoid];
    for (MGMChartEntry* entry in weeklyChart.chartEntries)
    {
        [self renderChartEntry:entry];
    }
}

- (void) renderChartEntry:(MGMChartEntry*)chartEntry
{
    MGMWeeklyChartView* weeklyChartView = (MGMWeeklyChartView*)self.view;

    NSUInteger rank = chartEntry.rank.intValue;
    NSUInteger listeners = chartEntry.listeners.intValue;

    MGMAlbumView* albumView = [weeklyChartView.albumGridView albumViewForRank:rank];
    [self displayAlbum:chartEntry.album inAlbumView:albumView rank:rank listeners:listeners completion:^(NSError* error) {
        [self.ui logError:error];
    }];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self dismissModalPresentation];
    MGMTimePeriod* timePeriod = [self.dataSource objectAtIndexPath:indexPath];
    [self loadAlbumsForPeriod:timePeriod];
}

#pragma mark -
#pragma mark MGMAlbumGridViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess mainThreadVersion:self.weeklyChartMoid];
    MGMChartEntry* entry = [weeklyChart.chartEntries objectAtIndex:rank - 1];
    [self.albumSelectionDelegate albumSelected:entry.album];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess mainThreadVersion:self.weeklyChartMoid];
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
