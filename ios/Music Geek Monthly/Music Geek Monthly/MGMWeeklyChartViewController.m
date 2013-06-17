
#import "MGMWeeklyChartViewController.h"
#import "MGMGroupAlbum.h"
#import "MGMAlbumsView.h"

@interface MGMWeeklyChartViewController() <MGMAlbumsViewDelegate>

@property (strong) MGMAlbumsView* albumsView;

@property (strong) NSArray* albums;
@property NSUInteger rowCount;
@property CGFloat albumSize;

@end

@implementation MGMWeeklyChartViewController

#define CELL_ID @"SimpleTableItem"

- (void) viewDidLoad
{
	self.albumsView = [[MGMAlbumsView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.albumsView.delegate = self;
	[self.view addSubview:self.albumsView];

    self.rowCount = 2;
    self.albumSize = 160;
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
            [self reloadData];
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

- (void) reloadData
{
    [self.albumsView clearAllAlbums];
    for (MGMGroupAlbum* album in self.albums)
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
    rank--;
    CGFloat y = rank / self.rowCount;
    CGFloat x = (rank % self.rowCount);
    CGFloat size = self.albumSize;
    //    if (large && x < (self.rowCount - 1))
    //    {
    //        size *= 2;
    //    }
    return CGRectMake(x * size, y * size, size, size);
}

- (void) renderAlbum:(MGMGroupAlbum*)album
{
    CGRect frame = [self calculatePositionForRank:album.rank];

    NSUInteger albumType = (album.rank % 3) + 1;
    NSString* imageName = [NSString stringWithFormat:@"album%d.png", albumType];
    UIImage* image = [UIImage imageNamed:imageName];
    [self.albumsView addAlbum:image artistName:album.artistName albumName:album.albumName rank:album.rank listeners:album.listeners atFrame:frame];

//    NSString* albumArtUri = [self bestImageForAlbum:album];
//    if (albumArtUri)
//    {
//        UIImage* image = [self.ui.imageCache imageFromUrl:albumArtUri];
//        cell.imageView.image = image;
//    }
}

#pragma mark -
#pragma mark MGMAlbumsViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    NSURL* defaultUrl = [NSURL URLWithString:@"spotify:"];
    if ([[UIApplication sharedApplication] canOpenURL:defaultUrl])
    {
        MGMGroupAlbum* album = [self.albums objectAtIndex:rank];
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
