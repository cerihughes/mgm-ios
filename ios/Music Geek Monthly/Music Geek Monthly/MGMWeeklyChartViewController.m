
#import "MGMWeeklyChartViewController.h"
#import "MGMWeeklyChartAlbumsView.h"
#import "MGMGroupAlbum.h"
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

@property (strong) NSArray* groupAlbums;

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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.timePeriods = [self.core.daoFactory.lastFmDao weeklyTimePeriods];
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
    });
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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        self.groupAlbums = [self.core.daoFactory.lastFmDao topWeeklyAlbums:ALBUMS_IN_CHART forTimePeriod:timePeriod];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self reloadData];
        });
    });
}

- (void) reloadData
{
    for (MGMGroupAlbum* album in self.groupAlbums)
    {
        [self.albumsView setActivityInProgress:YES forRank:album.rank];
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                // Search in a background thread...
                [self.core.daoFactory.lastFmDao updateAlbumInfo:album];
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    // ... but update the UI in the main thread...
                    [self renderAlbum:album];
                });
            });
        }
        else
        {
            [self renderAlbum:album];
        }
    }
}

- (void) renderAlbum:(MGMGroupAlbum*)album
{
    NSUInteger rank = album.rank;

    NSString* albumArtUri = [album bestAlbumImageUrl];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
        {
            [self.albumsView setActivityInProgress:NO forRank:album.rank];
            [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:rank listeners:album.listeners];
        }];
    }
    else
    {
        NSUInteger albumType = (album.rank % 3) + 1;
        NSString* imageName = [NSString stringWithFormat:@"album%d.png", albumType];
        UIImage* image = [UIImage imageNamed:imageName];
        [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:rank listeners:album.listeners];
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
    MGMAlbum* album = [self.groupAlbums objectAtIndex:rank - 1];
    [self.albumSelectionDelegate albumSelected:album];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    MGMAlbum* album = [self.groupAlbums objectAtIndex:rank - 1];
    [self.albumSelectionDelegate detailSelected:album];
}

@end
