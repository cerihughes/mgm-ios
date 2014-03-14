
#import "MGMUI.h"

#import "MGMAlbumDetailViewController.h"
#import "MGMReachabilityManager.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMUI () <MGMReachabilityManagerListener>

@property (readonly) MGMReachabilityManager* reachabilityManager;
@property (readonly) MGMAlbumDetailViewController* albumDetailViewController;

@end

@implementation MGMUI

#define REACHABILITY_END_POINT @"music-geek-monthly.appspot.com"

static BOOL _isIpad;

+ (void) initialize
{
    _isIpad = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

- (id) init
{
    if (self = [super init])
    {
        _core = [[MGMCore alloc] init];

        _albumDetailViewController = [[MGMAlbumDetailViewController alloc] init];
        _albumDetailViewController.ui = self;

        if (_isIpad)
        {
            _albumDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        }

        _mainController = [[MGMNavigationController alloc] initWithUI:self];

        _albumPlayer = [[MGMAlbumPlayer alloc] init];
        _albumPlayer.serviceManager = self.core.serviceManager;
        _albumPlayer.ui = self;

        _imageHelper = [[MGMImageHelper alloc] init];

        _reachabilityManager = [[MGMReachabilityManager alloc] init];
        [_reachabilityManager registerForReachabilityTo:REACHABILITY_END_POINT];
        [_reachabilityManager addListener:self];
    }
    return self;
}

- (BOOL) ipad
{
    return _isIpad;
}

- (void) uiWillResignActive
{

}

- (void) uiDidEnterBackground
{

}

- (void) uiWillEnterForeground
{

}

- (void) uiDidBecomeActive
{
    [self.mainController checkPlayer];
}

- (NSString*) labelForServiceType:(MGMAlbumServiceType)serviceType
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeLastFm:
            return @"last.fm";
        case MGMAlbumServiceTypeSpotify:
            return @"Spotify";
        case MGMAlbumServiceTypeWikipedia:
            return @"Wikipedia";
        case MGMAlbumServiceTypeYouTube:
            return @"YouTube";
        case MGMAlbumServiceTypeItunes:
            return @"iTunes";
        case MGMAlbumServiceTypeDeezer:
            return @"Deezer";
        default:
            return nil;
    }
}

- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeLastFm:
            return [UIImage imageNamed:@"lastfm.png"];
        case MGMAlbumServiceTypeSpotify:
            return [UIImage imageNamed:@"spotify.png"];
        case MGMAlbumServiceTypeWikipedia:
            return [UIImage imageNamed:@"wikipedia.png"];
        case MGMAlbumServiceTypeYouTube:
            return [UIImage imageNamed:@"youtube.png"];
        case MGMAlbumServiceTypeItunes:
            return [UIImage imageNamed:@"itunes.png"];
        case MGMAlbumServiceTypeDeezer:
            return [UIImage imageNamed:@"deezer.png"];
        default:
            return nil;
    }
}

- (void) showError:(NSError*)error
{
    [self logError:error];
    
    NSString* message = [NSString stringWithFormat:@"An error has prevented this operation from completing. The details have been sent to the developer for investigation.\n\n Details: %@", [error localizedDescription]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void) logError:(NSError*)error
{
    if (error)
    {
        NSLog(@"Error occurred: %@", error);
    }
}

#pragma mark -
#pragma mark MGMReachabilityManagerListener

- (void) reachabilityDetermined:(BOOL)reachability
{
    self.core.reachability = reachability;
}

#pragma mark -
#pragma mark MGMAlbumSelectionDelegate

- (void) albumSelected:(MGMAlbum*)album
{
    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;
    if (defaultServiceType == MGMAlbumServiceTypeNone)
    {
        [self detailSelected:album sender:self.mainController];
    }
    else
    {
        [self.albumPlayer playAlbum:album onService:defaultServiceType completion:^(NSError* error) {
            if (error != nil)
            {
                [self showError:error];
            }
        }];
    }
}

- (void) detailSelected:(MGMAlbum*)album sender:(UIViewController*)sender
{
    self.albumDetailViewController.albumMoid = album.objectID;
    [sender presentViewController:self.albumDetailViewController animated:YES completion:NULL];
}

#pragma mark -
#pragma mark MGMPlaylistSelectionDelegate

- (void) playlistSelected:(MGMPlaylist*)playlist
{
    [self.albumPlayer playPlaylist:playlist onService:MGMAlbumServiceTypeSpotify completion:^(NSError* error) {
        if (error != nil)
        {
            [self showError:error];
        }
    }];
}

@end
