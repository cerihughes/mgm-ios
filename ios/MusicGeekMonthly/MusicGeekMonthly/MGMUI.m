
#import "MGMUI.h"

#import "MGMAlbumDetailViewController.h"
#import "MGMExampleAlbumViewController.h"
#import "MGMNavigationViewController.h"
#import "MGMPlayerSelectionViewController.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMUI () <MGMPlayerSelectionViewControllerDelegate>

@property (strong) MGMAlbumDetailViewController* albumDetailViewController;
@property (strong) MGMPlayerSelectionViewController* playerSelectionViewController;
@property (strong) MGMExampleAlbumViewController* exampleAlbumViewController;

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
        [self setupCore];
        [self setupControllers];
        self.albumPlayer = [[MGMAlbumPlayer alloc] init];
        self.albumPlayer.daoFactory = self.core.daoFactory;
    }
    return self;
}

- (BOOL) ipad
{
    return _isIpad;
}

- (void) setupCore
{
    self.core = [[MGMCore alloc] init];
}

- (void) setupControllers
{
    self.albumDetailViewController = [[MGMAlbumDetailViewController alloc] init];
    self.albumDetailViewController.ui = self;

    self.playerSelectionViewController = [[MGMPlayerSelectionViewController alloc] init];
    self.playerSelectionViewController.ui = self;
    self.playerSelectionViewController.delegate = self;

    self.exampleAlbumViewController = [[MGMExampleAlbumViewController alloc] init];
    self.exampleAlbumViewController.ui = self;

    if (self.ipad)
    {
        self.albumDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        self.playerSelectionViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        self.exampleAlbumViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }

    MGMNavigationViewController* navigationController = [[MGMNavigationViewController alloc] initWithUI:self];
    self.parentViewController = navigationController;
}

- (void) start
{
    // Determine if a default player has been set...
    MGMAlbumServiceType defaultServiceType = self.core.daoFactory.settingsDao.defaultServiceType;

    // Determine current capabilities...
    NSUInteger lastCapabilities = self.core.daoFactory.settingsDao.lastCapabilities;
    NSUInteger newCapabilities = [self.albumPlayer determineCapabilities];
    self.core.daoFactory.settingsDao.lastCapabilities = newCapabilities;

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
    MGMAlbumServiceType defaultServiceType = self.core.daoFactory.settingsDao.defaultServiceType;
    if (defaultServiceType == MGMAlbumServiceTypeNone)
    {
        [self detailSelected:album sender:self.parentViewController];
    }
    else
    {
        NSError* error = nil;
        [self.albumPlayer playAlbum:album onService:defaultServiceType completion:^(NSError* updateError) {
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
