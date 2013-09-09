
#import "MGMWeeklyChartViewController.h"

#import "MGMCoreDataTableViewDataSource.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"
#import "MGMWeeklyChartAlbumsView.h"

@interface MGMWeeklyChartViewController () <MGMWeeklyChartAlbumsViewDelegate, UITableViewDelegate>

@property (strong) IBOutlet UINavigationItem* weeklyChartNavigationItem;
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
    }
    return self;
}

- (IBAction) barButtonPressed:(id)sender
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
        [self showError:error];
    }

    [self.timePeriodTable reloadData];

    BOOL iPad = self.view.frame.size.width > 320;
    NSUInteger albumCount = 25;
    NSUInteger rowCount = iPad ? 4 : 2;
    NSUInteger columnCount = (albumCount + 3) / rowCount;
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
    self.weeklyChartNavigationItem.title = timePeriod.groupValue;

    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.albumsView setActivityInProgressForAllRanks:YES];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [self.core.daoFactory.lastFmDao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMWeeklyChart* weeklyChart, NSError* fetchError)
        {
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
        }];
    });
}

- (void) reloadData
{
    MGMWeeklyChart* weeklyChart = [self.core.daoFactory.coreDataDao threadVersion:self.weeklyChartMoid];
    for (MGMChartEntry* entry in weeklyChart.chartEntries)
    {
        MGMAlbum* album = entry.album;
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album completion:^(MGMAlbum* updatedAlbum, NSError* fetchError)
            {
                if (fetchError && updatedAlbum)
                {
                    [self logError:fetchError];
                }

                if (updatedAlbum)
                {
                    entry.album = updatedAlbum;
                    [self renderChartEntry:entry];
                }
                else
                {
                    [self showError:fetchError];
                }
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
                [self logError:error];
            }

            if (image == nil)
            {
                image = [self defaultImageForRank:rank];
            }

            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.albumsView setActivityInProgress:NO forRank:rank];
                [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:rank listeners:listeners];
            });
        }];
    }
    else
    {
        UIImage* image = [self defaultImageForRank:rank];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.albumsView setActivityInProgress:NO forRank:rank];
            [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:rank listeners:listeners];
        });
    }
}

- (UIImage*) defaultImageForRank:(NSUInteger)rank
{
    NSUInteger albumType = (rank % 3) + 1;
    NSString* imageName = [NSString stringWithFormat:@"album%d.png", albumType];
    return [UIImage imageNamed:imageName];
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
