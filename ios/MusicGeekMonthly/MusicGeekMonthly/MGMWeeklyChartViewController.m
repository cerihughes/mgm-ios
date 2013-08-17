
#import "MGMWeeklyChartViewController.h"
#import "MGMWeeklyChartAlbumsView.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"

#define ALBUMS_IN_CHART 15

@interface MGMWeeklyChartViewController () <MGMWeeklyChartAlbumsViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong) IBOutlet UITableView* timePeriodTable;
@property (strong) IBOutlet MGMWeeklyChartAlbumsView* albumsView;
@property (strong) IBOutlet UIViewController* iPhone2ndController;

@property (strong) NSArray* timePeriods;
@property (strong) NSMutableArray* timePeriodTitles;
@property (strong) NSMutableDictionary* timePeriodMap;

@property (strong) MGMWeeklyChart* weeklyChart;

@property (strong) NSDateFormatter* dateFormatter;
@property (strong) NSDateFormatter* groupHeaderFormatter;
@property (strong) NSDateFormatter* groupItemFormatter;

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

        // dd MMM
        self.groupItemFormatter = [[NSDateFormatter alloc] init];
        [self.groupItemFormatter setDateFormat:@"dd MMM"];

        // MMM yyyy
        self.groupHeaderFormatter = [[NSDateFormatter alloc] init];
        self.groupHeaderFormatter.dateFormat = @"MMM yyyy";
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.albumsView.delegate = self;
    self.timePeriodTable.dataSource = self;
    self.timePeriodTable.delegate = self;

    BOOL iPad = self.view.frame.size.width > 320;
    NSUInteger rowCount = iPad ? 3 : 2;
    CGFloat albumSize = self.albumsView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:15 size:albumSize count:15];

    for (NSUInteger i = 0; i < ALBUMS_IN_CHART; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [self.albumsView setupAlbumFrame:frame forRank:i + 1];
    }

    [self.core.daoFactory.lastFmDao fetchAllTimePeriods:^(NSArray* timePeriods, NSError* error)
    {
        self.timePeriods = timePeriods;
        if (error != nil)
        {
            [self handleError:error];
            return;
        }

        [self processTimePeriods];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self.timePeriodTable reloadData];
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.timePeriodTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];

            MGMTimePeriod* timePeriod = [self.timePeriods objectAtIndex:0];
            if (self.iPhone2ndController == nil)
            {
                // Only auto-populate on iPad...
                [self loadAlbumsForPeriod:timePeriod];
            }
        });
    }];
}

- (void) processTimePeriods
{
    self.timePeriodTitles = [NSMutableArray arrayWithCapacity:24];
    self.timePeriodMap = [NSMutableDictionary dictionaryWithCapacity:24];

    for (MGMTimePeriod* period in self.timePeriods)
    {
        NSMutableArray* month = [self groupForDate:period.startDate];
        [month addObject:period];
    }
}

- (NSMutableArray*) groupForDate:(NSDate*)startDate
{
    NSString* formatted = [self.groupHeaderFormatter stringFromDate:startDate];
    if (![self.timePeriodTitles containsObject:formatted])
    {
        [self.timePeriodTitles addObject:formatted];
        [self.timePeriodMap setObject:[NSMutableArray arrayWithCapacity:5] forKey:formatted];
    }
    return [self.timePeriodMap objectForKey:formatted];
}

- (void) loadAlbumsForPeriod:(MGMTimePeriod*)timePeriod
{
    if (self.iPhone2ndController)
    {
        [self.navigationController pushViewController:self.iPhone2ndController animated:YES];
        self.iPhone2ndController.title = [self titleForTimePeriod:timePeriod];
    }
    else
    {
        self.title = [self titleForTimePeriod:timePeriod];
    }

    [self.core.daoFactory.lastFmDao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMWeeklyChart* weeklyChart, NSError* fetchError)
    {
        self.weeklyChart = weeklyChart;
        if (fetchError)
        {
            [self handleError:fetchError];
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self reloadData];
        });
    }];
}

- (void) reloadData
{
    for (MGMChartEntry* entry in [self.weeklyChart fetchChartEntries])
    {
        MGMAlbum* album = [entry fetchAlbum];
        [self.albumsView setActivityInProgress:YES forRank:entry.rank.intValue];
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album completion:^(MGMAlbum* updatedAlbum, NSError* fetchError)
            {
                if (fetchError != nil)
                {
                    [self handleError:fetchError];
                    return;
                }

                // We need to get the updated chart entry that contains this album... Not sure I should be going directly to the core data dao here...
                [self.core.daoFactory.coreDataDao fetchChartEntryWithWeeklyChart:self.weeklyChart rank:entry.rank completion:^(MGMChartEntry* updatedEntry, NSError* entryFetchError)
                {
                    if (entryFetchError != nil)
                    {
                        [self handleError:entryFetchError];
                        return;
                    }

                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        // ... but update the UI in the main thread...
                        [self renderChartEntry:updatedEntry];
                    });
                }];
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

    NSString* albumArtUri = [chartEntry fetchBestAlbumImageUrl];
    MGMAlbum* album = [chartEntry fetchAlbum];
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
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.timePeriodTitles.count;
}

- (NSMutableArray*) arrayForSection:(NSUInteger)section
{
    NSString* title = [self.timePeriodTitles objectAtIndex:section];
    return [self.timePeriodMap objectForKey:title];
}

- (MGMTimePeriod*) timePeriodForIndexPath:(NSIndexPath*)path
{
    NSMutableArray* array = [self arrayForSection:path.section];
    return [array objectAtIndex:path.row];
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* array = [self arrayForSection:section];
    return array.count;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.timePeriodTitles objectAtIndex:section];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    
    MGMTimePeriod* timePeriod = [self timePeriodForIndexPath:indexPath];
    cell.textLabel.text = [self titleForTimePeriod:timePeriod];
    return cell;
}

- (NSString*) titleForTimePeriod:(MGMTimePeriod*)period
{
    NSString* startString = [self.groupItemFormatter stringFromDate:period.startDate];
    NSString* endString = [self.groupItemFormatter stringFromDate:period.endDate];
    return [NSString stringWithFormat:@"%@ - %@", startString, endString];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMTimePeriod* timePeriod = [self timePeriodForIndexPath:indexPath];
    [self loadAlbumsForPeriod:timePeriod];
}

#pragma mark -
#pragma mark MGMWeeklyChartAlbumsViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    MGMChartEntry* entry = [[self.weeklyChart fetchChartEntries] objectAtIndex:rank - 1];
    [self.albumSelectionDelegate albumSelected:[entry fetchAlbum]];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    MGMChartEntry* entry = [[self.weeklyChart fetchChartEntries] objectAtIndex:rank - 1];
    [self.albumSelectionDelegate detailSelected:[entry fetchAlbum]];
}

@end
