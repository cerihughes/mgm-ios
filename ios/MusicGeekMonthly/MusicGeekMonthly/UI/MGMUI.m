
#import "MGMUI.h"

#import "MGMAlbumDetailViewController.h"
#import "MGMExampleAlbumViewController.h"
#import "MGMPlayerSelectionViewController.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMUI () <MGMPlayerSelectionViewControllerDelegate>

@property (readonly) MGMAlbumDetailViewController* albumDetailViewController;
@property (readonly) MGMPlayerSelectionViewController* playerSelectionViewController;
@property (readonly) MGMExampleAlbumViewController* exampleAlbumViewController;

@end

@implementation MGMUI

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

        _playerSelectionViewController = [[MGMPlayerSelectionViewController alloc] init];
        _playerSelectionViewController.ui = self;
        _playerSelectionViewController.delegate = self;

        _exampleAlbumViewController = [[MGMExampleAlbumViewController alloc] init];
        _exampleAlbumViewController.ui = self;

        if (_isIpad)
        {
            _albumDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            _playerSelectionViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            _exampleAlbumViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        }

        _parentViewController = [[MGMNavigationViewController alloc] initWithUI:self];;

        _albumPlayer = [[MGMAlbumPlayer alloc] init];
        _albumPlayer.serviceManager = self.core.serviceManager;
        _albumPlayer.ui = self;

        _imageHelper = [[MGMImageHelper alloc] init];
        _viewUtilities = [[MGMAlbumViewUtilities alloc] initWithImageHelper:_imageHelper renderService:_core.albumRenderService];
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
    [self.parentViewController startRending];

    // This should be driven from a callback?
    [self performSelector:@selector(checkPlayer) withObject:nil afterDelay:0.5];
}

- (void) checkPlayer
{
    // Determine if a default player has been set...
    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;

    // Determine current capabilities...
    NSUInteger lastCapabilities = self.core.settingsDao.lastCapabilities;
    NSUInteger newCapabilities = [self.albumPlayer determineCapabilities];
    self.core.settingsDao.lastCapabilities = newCapabilities;

    MGMPlayerSelectionMode playerSelectionMode = MGMPlayerSelectionModeNone;

    if (defaultServiceType == MGMAlbumServiceTypeNone)
    {
        // None set yet - 1st launch...
        playerSelectionMode = MGMPlayerSelectionModeNoPlayer;
    }
    else
    {
        // Check that the selected service type is still available...
        if (newCapabilities & defaultServiceType)
        {
            // Service type still available. Finally check for new service types...
            if (newCapabilities != lastCapabilities)
            {
                playerSelectionMode = MGMPlayerSelectionModeNewPlayers;
            }
        }
        else
        {
            // Service type no longer available.
            playerSelectionMode = MGMPlayerSelectionModePlayerRemoved;
        }
    }

    if (playerSelectionMode != MGMPlayerSelectionModeNone)
    {
        self.playerSelectionViewController.existingServiceType = defaultServiceType;
        self.playerSelectionViewController.mode = playerSelectionMode;
        [self.parentViewController presentViewController:self.playerSelectionViewController animated:YES completion:NULL];
    }
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
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSString* message = [NSString stringWithFormat:@"An error has prevented this operation from completing. The details have been sent to the developer for investigation.\n\n Details: %@", [error localizedDescription]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    });
    [self logError:error];
}

- (void) logError:(NSError*)error
{
    NSLog(@"Error occurred: %@", error);
}

#pragma mark -
#pragma mark MGMAlbumSelectionDelegate

- (void) albumSelected:(MGMAlbum*)album
{
    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;
    if (defaultServiceType == MGMAlbumServiceTypeNone)
    {
        [self detailSelected:album sender:self.parentViewController];
    }
    else
    {
        NSError* error = nil;
        // TODO: Make this asynchronous?
        [self.albumPlayer playAlbum:album onService:defaultServiceType error:&error];
        if (error != nil)
        {
            [self showError:error];
        }
    }
}

- (void) detailSelected:(MGMAlbum*)album sender:(UIViewController*)sender
{
    self.albumDetailViewController.albumMoid = album.objectID;
    [sender presentViewController:self.albumDetailViewController animated:YES completion:NULL];
}

#pragma mark -
#pragma mark MGMPlayerSelectionViewControllerDelegate

- (void) playerSelectionChangedFrom:(MGMAlbumServiceType)oldSelection to:(MGMAlbumServiceType)newSelection
{
    if (oldSelection == MGMAlbumServiceTypeNone)
    {
        // 1st run...
        [self.parentViewController presentViewController:self.exampleAlbumViewController animated:YES completion:NULL];
    }
}

@end
