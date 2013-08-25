
#import "MGMWeeklyChartViewController.h"

#import "MGMCoreDataTableViewDataSource.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"
#import "MGMWeeklyChartAlbumsView.h"

@interface MGMWeeklyChartViewController () <MGMWeeklyChartAlbumsViewDelegate, UITableViewDelegate>

@property (strong) IBOutlet UITableView* timePeriodTable;
@property (strong) IBOutlet MGMWeeklyChartAlbumsView* albumsView;

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

        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"More..." style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPressed:)];
        self.navigationItem.rightBarButtonItem = item;
    }
    return self;
}

- (void) barButtonPressed:(id)sender
{
    if ([self isPresentingModally])
    {
        [self dismissModalPresentation];
    }
    else
    {
        [self presentViewModally:self.timePeriodTable sender:sender];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    NSFetchedResultsController* fetchedResultsController = [self.core.daoFactory.coreDataDao createTimePeriodsFetchedResultsController];
    self.dataSource = [[MGMCoreDataTableViewDataSource alloc] initWithCellId:CELL_ID];
    self.dataSource.fetchedResultsController = fetchedResultsController;

    self.albumsView.delegate = self;
    self.timePeriodTable.dataSource = self.dataSource;
    self.timePeriodTable.delegate = self;

    NSError* error = nil;
    [fetchedResultsController performFetch:&error];
    if (error != nil)
    {
        [self handleError:error];
    }

    [self.timePeriodTable reloadData];

    BOOL iPad = self.view.frame.size.width > 320;
    NSUInteger rowCount = iPad ? 4 : 2;
    NSUInteger columnCount = iPad ? 7 : 9;
    NSUInteger albumCount = iPad ? 25 : 15;
    CGFloat albumSize = self.albumsView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [self.albumsView setupAlbumFrame:frame forRank:i + 1];
    }

    // Auto-populate for 1st entry...
    NSIndexPath* firstItem = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.timePeriodTable selectRowAtIndexPath:firstItem animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.timePeriodTable didSelectRowAtIndexPath:firstItem];
}

- (void) loadAlbumsForPeriod:(MGMTimePeriod*)timePeriod
{
    self.title = timePeriod.groupValue;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [self.core.daoFactory.lastFmDao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMWeeklyChart* weeklyChart, NSError* fetchError)
        {
            if (fetchError)
            {
                [self handleError:fetchError];
            }

            if (weeklyChart)
            {
                self.weeklyChartMoid = weeklyChart.objectID;
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    // ... but update the UI in the main thread...
                    [self reloadData];
                });
            }
        }];
    });
}

- (void) reloadData
{
    MGMWeeklyChart* weeklyChart = [self.core.daoFactory.coreDataDao threadVersion:self.weeklyChartMoid];
    for (MGMChartEntry* entry in weeklyChart.chartEntries)
    {
        MGMAlbum* album = entry.album;
        [self.albumsView setActivityInProgress:YES forRank:entry.rank.intValue];
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album completion:^(MGMAlbum* updatedAlbum, NSError* fetchError)
            {
                if (fetchError != nil)
                {
                    [self handleError:fetchError];
                }

                entry.album = updatedAlbum;

                dispatch_async(dispatch_get_main_queue(), ^
                {
                    // ... but update the UI in the main thread...
                    [self renderChartEntry:entry];
                });
            }];
        }
        else
        {
            [self renderChartEntry:entry];
        }
    }
}

- (void) renderChartEntry:(MGMChartEntry*)chartEntry
{
    NSUInteger rank = chartEntry.rank.intValue;
    NSUInteger listeners = chartEntry.listeners.intValue;

    NSString* albumArtUri = [chartEntry bestAlbumImageUrl];
    MGMAlbum* album = chartEntry.album;
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage* image, NSError* error)
        {
            if (error)
            {
                [self handleError:error];
            }
            else
            {
                [self.albumsView setActivityInProgress:NO forRank:rank];
                [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:rank listeners:listeners];
            }
        }];
    }
    else
    {
        NSUInteger albumType = (rank % 3) + 1;
        NSString* imageName = [NSString stringWithFormat:@"album%d.png", albumType];
        UIImage* image = [UIImage imageNamed:imageName];
        [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:rank listeners:listeners];
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
#pragma mark MGMWeeklyChartAlbumsViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    MGMWeeklyChart* weeklyChart = [self.core.daoFactory.coreDataDao threadVersion:self.weeklyChartMoid];
    MGMChartEntry* entry = [weeklyChart.chartEntries objectAtIndex:rank - 1];
    [self.albumSelectionDelegate albumSelected:entry.album];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    MGMWeeklyChart* weeklyChart = [self.core.daoFactory.coreDataDao threadVersion:self.weeklyChartMoid];
    MGMChartEntry* entry = [weeklyChart.chartEntries objectAtIndex:rank - 1];
    [self.albumSelectionDelegate detailSelected:entry.album];
}

@end
