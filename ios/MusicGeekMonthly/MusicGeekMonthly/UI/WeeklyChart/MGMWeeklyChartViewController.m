
#import "MGMWeeklyChartViewController.h"

#import "MGMAlbumGridView.h"
#import "MGMChartEntry.h"
#import "MGMCore.h"
#import "MGMCoreDataAccess.h"
#import "MGMCoreDataTableViewDataSource.h"
#import "MGMDao.h"
#import "MGMDaoData.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"
#import "MGMTimePeriod.h"
#import "MGMUI.h"
#import "MGMWeeklyChart.h"
#import "MGMWeeklyChartModalView.h"
#import "UIViewController+MGMAdditions.h"

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
    NSUInteger albumCount = 25;
    [self.view.albumGridView setAlbumCount:albumCount detailViewShowing:YES];
    CGFloat gridWidth = self.view.albumGridView.frame.size.width;
    NSUInteger rowCount = 2;
    if (gridWidth > 768) {
        rowCount = 5;
    } else if (gridWidth > 414) {
        rowCount = 4;
    } else if (gridWidth > 375) {
        rowCount = 3;
    }
    CGFloat albumSize = self.view.albumGridView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRowSize:rowCount defaultRectSize:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [self.view.albumGridView setAlbumFrame:frame forRank:i + 1];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.core.dao fetchAllTimePeriods:^(MGMDaoData* timePeriodData) {
        NSArray* moids = timePeriodData.data;
        if (timePeriodData.error && moids.count == 0)
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
    [self.view setTitle:timePeriod.groupValue];
    [self.view.albumGridView setActivityInProgressForAllRanks:YES];

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
    NSUInteger rank = chartEntry.rank.intValue;
    NSUInteger listeners = chartEntry.listeners.intValue;

    MGMAlbumView* albumView = [self.view.albumGridView albumViewForRank:rank];
    [self displayAlbum:chartEntry.album inAlbumView:albumView rank:rank listeners:listeners completion:^(NSError* error) {
        [self.ui logError:error];
    }];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self dismissModalPresentation:self.modalView];
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
    if ([self isPresentingModally:self.modalView])
    {
        [self dismissModalPresentation:self.modalView];
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
