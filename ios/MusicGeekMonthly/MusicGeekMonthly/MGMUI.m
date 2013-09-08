
#import "MGMUI.h"

#import "MGMAlbumDetailViewController.h"
#import "MGMAlbumSelectionDelegate.h"
#import "MGMEventsViewController.h"
#import "MGMHomeViewController.h"
#import "MGMTransitionViewController.h"
#import "MGMWebViewController.h"
#import "MGMWeeklyChartViewController.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMUI () <MGMHomeViewControllerDelegate, MGMAlbumSelectionDelegate>

@property (retain) NSMutableDictionary* transitions;

- (void) setupCore;
- (void) setupControllers;

@end

@implementation MGMUI

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

- (void) setupCore
{
    self.core = [[MGMCore alloc] init];
}

- (void) setupControllers
{
    self.transitions = [NSMutableDictionary dictionary];

    MGMHomeViewController* homeViewController = [[MGMHomeViewController alloc] init];
    homeViewController.ui = self;
    [self.transitions setObject:homeViewController forKey:TO_HOME];
    homeViewController.delegate = self;
    homeViewController.title = @"Home";
    homeViewController.albumSelectionDelegate = self;

    MGMWeeklyChartViewController* weeklyChartViewController = [[MGMWeeklyChartViewController alloc] init];
    weeklyChartViewController.ui = self;
    [self.transitions setObject:weeklyChartViewController forKey:TO_CHART];
    weeklyChartViewController.title = @"Weekly Charts";
    weeklyChartViewController.albumSelectionDelegate = self;

    MGMEventsViewController* eventsViewController = [[MGMEventsViewController alloc] init];
    eventsViewController.ui = self;
    [self.transitions setObject:eventsViewController forKey:TO_PLAYLISTS];
    eventsViewController.title = @"Previous Events";
    eventsViewController.albumSelectionDelegate = self;

    MGMWebViewController* webViewController = [[MGMWebViewController alloc] init];
    webViewController.ui = self;
    [self.transitions setObject:webViewController forKey:TO_WEB];
    webViewController.title = @"Web";

    MGMAlbumDetailViewController* albumDetailViewController = [[MGMAlbumDetailViewController alloc] init];
    albumDetailViewController.ui = self;
    [self.transitions setObject:albumDetailViewController forKey:TO_ALBUM_DETAIL];
    albumDetailViewController.title = @"Album Detail";

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];

    self.parentViewController = navigationController;
}

- (void) transition:(NSString *)transition
{
    [self transition:transition withState:nil];
}

- (void) transition:(NSString *)transition withState:(id)state
{
    UINavigationController* navigationController = (UINavigationController*)self.parentViewController;
    UIViewController* nextController = [self.transitions objectForKey:transition];
    [navigationController pushViewController:nextController animated:YES];
    [nextController transitionCompleteWithState:state];
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

- (NSString*) transitionForOption:(MGMHomeViewControllerOption)option
{
    switch (option) {
        case MGMHomeViewControllerOptionPreviousEvents:
            return TO_PLAYLISTS;
        case MGMHomeViewControllerOptionCharts:
            return TO_CHART;
        default:
            return nil;
    }
}

- (void) navigateToWebPanel:(NSString*)uri
{
    [self transition:TO_WEB withState:uri];
}

- (void) showError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    });
    [self logError:error];
}

- (void) logError:(NSError*)error
{
    NSLog(@"Error occurred: %@", error);
}

#pragma mark -
#pragma mark MGMHomeViewControllerDelegate

- (void) optionSelected:(MGMHomeViewControllerOption)option
{
    [self transition:[self transitionForOption:option]];
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

- (void) detailSelected:(MGMAlbum*)album
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self ipadDetailSelected:album];
    }
    else
    {
        [self iphoneDetailSelected:album];
    }
}

- (void) albumDetailDismissed
{
    // iphone is dealt with by the navigation back, so this never gets invoked.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self ipadDetailDismissed];
    }
}

- (void) ipadDetailSelected:(MGMAlbum*)album
{
    UIViewController* nextController = [self.transitions objectForKey:TO_ALBUM_DETAIL];
    [nextController transitionCompleteWithState:album];
    UINavigationController* navigationController = (UINavigationController*)self.parentViewController;
    nextController.modalPresentationStyle = UIModalPresentationFormSheet;
    [navigationController presentViewController:nextController animated:YES completion:NULL];
}

- (void) iphoneDetailSelected:(MGMAlbum*)album
{
    [self transition:TO_ALBUM_DETAIL withState:album];
}

- (void) ipadDetailDismissed
{
    UINavigationController* navigationController = (UINavigationController*)self.parentViewController;
    [navigationController dismissViewControllerAnimated:YES completion:NULL];
}

@end
