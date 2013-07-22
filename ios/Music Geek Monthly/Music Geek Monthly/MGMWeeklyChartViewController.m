
#import "MGMWeeklyChartViewController.h"
#import "MGMGroupAlbum.h"
#import "MGMAlbumsView.h"
#import "MGMGridManager.h"

@interface MGMWeeklyChartViewController () <MGMAlbumsViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UITableViewDelegate, UIPickerViewDelegate>

@property (strong) IBOutlet UITableView* timePeriodTable;
@property (strong) IBOutlet UIPickerView* timePeriodPicker;
@property (strong) IBOutlet MGMAlbumsView* albumsView;

@property (strong) NSArray* timePeriods;
@property (strong) NSMutableArray* timePeriodTitles;
@property (strong) NSMutableDictionary* timePeriodMap;

@property (strong) NSArray* groupAlbums;

@property (strong) NSDateFormatter* dateFormatter;
@property (strong) NSDateFormatter* groupHeaderFormatter;
@property (strong) NSDateFormatter* groupItemFormatter;

@property NSUInteger rowCount;
@property CGFloat albumSize;
@property (strong) NSArray* gridData;

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
    self.timePeriodPicker.dataSource = self;
    self.timePeriodPicker.delegate = self;
    self.timePeriodTable.dataSource = self;
    self.timePeriodTable.delegate = self;

    BOOL iPad = self.view.frame.size.width > 320;
    self.rowCount = iPad ? 3 : 2;
    self.albumSize = self.albumsView.frame.size.width / self.rowCount;
    self.gridData = [MGMGridManager rectsForRows:self.rowCount columns:15 size:self.albumSize count:15];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.timePeriods = [self.core.daoFactory.lastFmDao weeklyTimePeriods];
        [self processTimePeriods];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self.timePeriodPicker reloadAllComponents];
            [self.timePeriodPicker selectRow:0 inComponent:0 animated:YES];

            [self.timePeriodTable reloadData];
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.timePeriodTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];

            MGMTimePeriod* timePeriod = [self.timePeriods objectAtIndex:0];
            [self loadAlbumsForPeriod:timePeriod];
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
    self.title = [self titleForTimePeriod:timePeriod];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        self.groupAlbums = [self.core.daoFactory.lastFmDao topWeeklyAlbumsForTimePeriod:timePeriod];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self reloadData];
        });
    });
}

- (NSString*) bestImageForAlbum:(MGMGroupAlbum*)album
{
    NSString* uri;
    if (album.rank == 1 && (uri = [self imageSize:IMAGE_SIZE_MEGA forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_EXTRA_LARGE forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_MEGA forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_LARGE forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_MEDIUM forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_SMALL forAlbum:album]) != nil)
    {
        return uri;
    }
    return nil;
}

- (NSString*) imageSize:(NSString*)size forAlbum:(MGMGroupAlbum*)album
{
    return [album.imageUris objectForKey:size];
}

- (void) reloadData
{
    [self.albumsView clearAllAlbums];
    for (MGMGroupAlbum* album in self.groupAlbums)
    {
        if (album.searchedLastFmData == NO)
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

- (CGRect) calculatePositionForRank:(NSUInteger)rank
{
    NSValue* value = [self.gridData objectAtIndex:rank - 1];
    return [value CGRectValue];
}

- (void) renderAlbum:(MGMGroupAlbum*)album
{
    NSUInteger rank = album.rank;
    CGRect frame = [self calculatePositionForRank:rank];

    NSUInteger albumType = (album.rank % 3) + 1;
    NSString* imageName = [NSString stringWithFormat:@"album%d.png", albumType];
    UIImage* image = [UIImage imageNamed:imageName];
    [self.albumsView addAlbum:image artistName:album.artistName albumName:album.albumName rank:rank listeners:album.listeners atFrame:frame];

    NSString* albumArtUri = [self bestImageForAlbum:album];
    if (albumArtUri)
    {
        [self.ui.imageCache asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
        {
            [self.albumsView updateAlbumImage:image atRank:rank];
        }];
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
#pragma mark UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.timePeriods.count;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMTimePeriod* timePeriod = [self timePeriodForIndexPath:indexPath];
    [self loadAlbumsForPeriod:timePeriod];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    MGMTimePeriod* period = [self.timePeriods objectAtIndex:row];
	NSString* startString = [self.dateFormatter stringFromDate:period.startDate];
	NSString* endString = [self.dateFormatter stringFromDate:period.endDate];
    return [NSString stringWithFormat:@"%@ - %@", startString, endString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    MGMTimePeriod* timePeriod = [self.timePeriods objectAtIndex:row];
    [self loadAlbumsForPeriod:timePeriod];
}

#pragma mark -
#pragma mark MGMAlbumsViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    NSURL* defaultUrl = [NSURL URLWithString:@"spotify:"];
    if ([[UIApplication sharedApplication] canOpenURL:defaultUrl])
    {
        MGMGroupAlbum* album = [self.groupAlbums objectAtIndex:rank];
        if (album.searchedSpotifyData == NO)
        {
            NSLog(@"Performing spotify search for %@ - %@", album.artistName, album.albumName);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                // Search in a background thread...
                [self.core.daoFactory.spotifyDao updateAlbumInfo:album];
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    // ... but invoke the UI in the main thread...
                    [self openAlbumInSpotify:album];
                });
            });
        }
        else
        {
            [self openAlbumInSpotify:album];
        }
    }
}

- (void) openAlbumInSpotify:(MGMGroupAlbum*)album
{
    NSString* uri = album.spotifyUri;
    if (uri)
    {
        NSURL* actualUrl = [NSURL URLWithString:uri];
        [[UIApplication sharedApplication] openURL:actualUrl];
    }
    else
    {
        // Report a problem.
    }
}

@end
