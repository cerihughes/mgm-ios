
#import "MGMUI.h"

#import "MGMAlbumDetailViewController.h"
#import "MGMNavigationViewController.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMUI ()

@property (strong) MGMAlbumDetailViewController* albumDetailViewController;

- (void) setupCore;
- (void) setupControllers;

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

    MGMNavigationViewController* navigationController = [[MGMNavigationViewController alloc] initWithUI:self];
    self.parentViewController = navigationController;
}

- (void) enteringBackground
{
    [self.core enteringBackground];
}

- (void) enteredForeground
{
    [self.core enteredForeground];
}

- (void) timeChanged
{
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
    NSError* error = nil;
    [self.albumPlayer playAlbum:album onService:MGMAlbumServiceTypeSpotify completion:^(NSError* updateError)
    {
        if (error != nil)
        {
            [self showError:error];
        }
    }];
}

- (void) detailSelected:(MGMAlbum*)album sender:(MGMViewController*)sender
{
    self.albumDetailViewController.albumMoid = album.objectID;
    if (self.ipad)
    {
        [self ipadDetailSelected:album sender:sender];
    }
    else
    {
        [self iphoneDetailSelected:album sender:sender];
    }
}

- (void) ipadDetailSelected:(MGMAlbum*)album sender:(MGMViewController*)sender
{
    self.albumDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [sender presentViewController:self.albumDetailViewController animated:YES completion:NULL];
}

- (void) iphoneDetailSelected:(MGMAlbum*)album sender:(MGMViewController*)sender
{
    [sender presentViewController:self.albumDetailViewController animated:YES completion:NULL];
}

@end
