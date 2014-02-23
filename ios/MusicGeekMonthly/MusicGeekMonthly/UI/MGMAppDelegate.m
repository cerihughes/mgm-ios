//
//  MGMAppDelegate.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAppDelegate.h"

#import "MGMNoReachabilityViewController.h"
#import "MGMReachabilityManager.h"
#import "MGMUI.h"
#import "TestFlight.h"

@interface MGMAppDelegate () <MGMReachabilityManagerListener>

@property (strong) MGMReachabilityManager* reachabilityManager;
@property (strong) MGMUI* ui;
@property (strong) MGMNoReachabilityViewController* noReachabilityViewController;

@end

@implementation MGMAppDelegate

#define REACHABILITY_END_POINT @"music-geek-monthly.appspot.com"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application:didFinishLaunchingWithOptions:");

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    [TestFlight takeOff:@"6e488aaf-18dc-44b8-9421-7088b6651302"];

    NSURLCache* cache = [[NSURLCache alloc] initWithMemoryCapacity:16 * 1024 * 1024 diskCapacity:128 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:cache];

    self.ui = [[MGMUI alloc] init];

    self.noReachabilityViewController = [[MGMNoReachabilityViewController alloc] init];
    self.noReachabilityViewController.ui = self.ui;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // By default, there is no reachability.
	self.window.rootViewController = self.noReachabilityViewController;
    [self.window makeKeyAndVisible];

    self.reachabilityManager = [[MGMReachabilityManager alloc] init];
    [self.reachabilityManager registerForReachabilityTo:REACHABILITY_END_POINT];
    [self.reachabilityManager addListener:self];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"application:openURL:sourceApplication:annotation:");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive:");
    if (self.window.rootViewController == self.ui.parentViewController)
    {
        [self.ui uiWillResignActive];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground:");
    if (self.window.rootViewController == self.ui.parentViewController)
    {
        [self.ui uiDidEnterBackground];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground:");
    if (self.window.rootViewController == self.ui.parentViewController)
    {
        [self.ui uiWillEnterForeground];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive:");
    if (self.window.rootViewController == self.ui.parentViewController)
    {
        [self.ui uiDidBecomeActive];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"applicationDidReceiveMemoryWarning:");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate:");
}

- (void)applicationSignificantTimeChange:(UIApplication *)application
{
    NSLog(@"applicationSignificantTimeChange:");
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"application:performFetchWithCompletionHandler:");
    MGMCoreBackgroundFetchResult coreFetchResult = [self.ui.core performBackgroundFetch];
    UIBackgroundFetchResult uiFetchResult = [self uiFetchResultForCoreFetchResult:coreFetchResult];
    NSLog(@"application:performFetchWithCompletionHandler: completed with %lu", (unsigned long)uiFetchResult);
    completionHandler(uiFetchResult);
}

- (UIBackgroundFetchResult) uiFetchResultForCoreFetchResult:(MGMCoreBackgroundFetchResult)coreFetchResult
{
    switch (coreFetchResult) {
        case MGMCoreBackgroundFetchResultNoData:
            return UIBackgroundFetchResultNoData;
        case MGMCoreBackgroundFetchResultNewData:
            return UIBackgroundFetchResultNewData;
        case MGMCoreBackgroundFetchResultFailed:
            return UIBackgroundFetchResultFailed;
    }
}

#pragma mark -
#pragma mark MGMReachabilityManagerListener

- (void) reachabilityDetermined:(BOOL)reachability
{
    self.ui.reachability = reachability;
    if (reachability == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Do we have enough data to proceed offline?
            MGMCoreBackgroundFetchResult coreFetchResult = [self.ui.core performBackgroundFetch];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (coreFetchResult != MGMCoreBackgroundFetchResultFailed)
                {
                    [self presentUI];
                }
            });
        });
    }
    else
    {
        [self presentUI];
    }
}

- (void) presentUI
{
    if (self.window.rootViewController != self.ui.parentViewController)
    {
        self.window.rootViewController = self.ui.parentViewController;
        [self.ui uiDidBecomeActive];
    }
}

@end
