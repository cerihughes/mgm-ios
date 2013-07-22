
#import "MGMUI.h"

#import "UIViewController+MGMAdditions.h"

#import "MGMTransitionViewController.h"
#import "MGMHomeViewController.h"
#import "MGMWeeklyChartViewController.h"
#import "MGMEventsViewController.h"
#import "MGMWebViewController.h"

@interface MGMUI () <MGMHomeViewControllerDelegate>

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
        self.imageCache = [[MGMImageCache alloc] init];
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

    MGMWeeklyChartViewController* weeklyChartViewController = [[MGMWeeklyChartViewController alloc] init];
    weeklyChartViewController.ui = self;
    [self.transitions setObject:weeklyChartViewController forKey:TO_CHART];
    weeklyChartViewController.title = @"Weekly Charts";

    MGMEventsViewController* eventsViewController = [[MGMEventsViewController alloc] init];
    eventsViewController.ui = self;
    [self.transitions setObject:eventsViewController forKey:TO_PLAYLISTS];
    eventsViewController.title = @"Previous Events";

    MGMWebViewController* webViewController = [[MGMWebViewController alloc] init];
    webViewController.ui = self;
    [self.transitions setObject:webViewController forKey:TO_WEB];
    webViewController.title = @"Web";

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];

    self.parentViewController = navigationController;

//    self.parentViewController = [[MGMTransitionViewController alloc] init];
//    self.parentViewController.initialViewController = homeViewController;
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

	if ([[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^
    {
		NSLog(@"Keepalive handler running.");
		[self.core keepAlive];
	}])
    {
		NSLog(@"Registered keepalive handler.");
	}
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
            break;
        case MGMHomeViewControllerOptionNextEvent:
            return nil;
            break;
        case MGMHomeViewControllerOptionCharts:
            return TO_CHART;
            break;
    }
}

#pragma mark -
#pragma mark MGMHomeViewControllerDelegate

- (void) optionSelected:(MGMHomeViewControllerOption)option
{
    [self transition:[self transitionForOption:option]];
}

@end
