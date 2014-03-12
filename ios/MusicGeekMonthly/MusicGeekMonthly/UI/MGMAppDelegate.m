//
//  MGMAppDelegate.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAppDelegate.h"

#import "MGMUI.h"
#import "TestFlight.h"

@interface MGMAppDelegate ()

@property (strong) MGMUI* ui;

@end

@implementation MGMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application:didFinishLaunchingWithOptions:");

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    [TestFlight takeOff:@"6e488aaf-18dc-44b8-9421-7088b6651302"];

    NSURLCache* cache = [[NSURLCache alloc] initWithMemoryCapacity:16 * 1024 * 1024 diskCapacity:128 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:cache];

    self.ui = [[MGMUI alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // By default, there is no reachability.
	self.window.rootViewController = self.ui.parentViewController;
    [self.window makeKeyAndVisible];

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
    [self.ui uiWillResignActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground:");
    [self.ui uiDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground:");
    [self.ui uiWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive:");
    [self.ui uiDidBecomeActive];
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
    [self.ui.core performBackgroundFetch:^(MGMCoreBackgroundFetchResult coreFetchResult) {
        UIBackgroundFetchResult uiFetchResult = [self uiFetchResultForCoreFetchResult:coreFetchResult];
        NSLog(@"application:performFetchWithCompletionHandler: completed with %lu", (unsigned long)uiFetchResult);
        completionHandler(uiFetchResult);
    }];
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

@end
