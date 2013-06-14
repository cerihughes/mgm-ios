
#import "MGMWeeklyChartViewController.h"
#import "MGMLastFmDao.h"
#import "MGMGroupAlbum.h"

@interface MGMWeeklyChartViewController() <UITableViewDataSource, UITableViewDelegate>

@property (strong) UITableView* tableView;
@property (strong) NSArray* albums;

@end

@implementation MGMWeeklyChartViewController

#define CELL_ID @"SimpleTableItem"

- (void) viewDidLoad
{
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
	[self.view addSubview:self.tableView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.albums = [self.core.daoFactory.lastFmDao topWeeklyAlbums];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self.tableView reloadData];
        });
    });
}

- (NSString*) bestImageForAlbum:(MGMGroupAlbum*)album
{
    NSString* uri;
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

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
    }

    NSUInteger row = indexPath.row;
    MGMGroupAlbum* album = [self.albums objectAtIndex:row];
    NSUInteger albumType = (row % 3) + 1;
    NSString* imageName = [NSString stringWithFormat:@"album%d.png", albumType];
    cell.textLabel.text = album.albumName;
    cell.detailTextLabel.text = album.artistName;
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMGroupAlbum* album = [self.albums objectAtIndex:indexPath.row];
    if (album.searchedLastFmData == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                [self renderAlbum:album inCell:cell];
            });
        });
    }
    else
    {
        [self renderAlbum:album inCell:cell];
    }
}

- (void) renderAlbum:(MGMGroupAlbum*)album inCell:(UITableViewCell*)cell
{
    NSString* albumArtUri = [self bestImageForAlbum:album];
    if (albumArtUri)
    {
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:albumArtUri]]];
        cell.imageView.image = image;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL* defaultUrl = [NSURL URLWithString:@"spotify:"];
    if ([[UIApplication sharedApplication] canOpenURL:defaultUrl])
    {
        MGMGroupAlbum* album = [self.albums objectAtIndex:indexPath.row];
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
    if (album.spotifyUri)
    {
        NSURL* actualUrl = [NSURL URLWithString:album.spotifyUri];
        [[UIApplication sharedApplication] openURL:actualUrl];
    }
    else
    {
        // Report a problem.
    }
}

@end
