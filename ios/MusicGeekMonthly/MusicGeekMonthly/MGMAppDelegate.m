//
//  MGMAppDelegate.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAppDelegate.h"
#import "MGMUI.h"
#import "MGMURLCache.h"
#import "TestFlight.h"

@interface MGMAppDelegate ()

@property (strong) MGMUI* ui;

@end

@implementation MGMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application:didFinishLaunchingWithOptions:");

    // TODO: - Use the next line only during beta
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];

    [TestFlight takeOff:@"4c193851-92f4-4a07-ac1f-2af55eb53f67"];

    MGMURLCache* cache = [[MGMURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:32 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:cache];

    self.ui = [[MGMUI alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
    [self.ui enteringBackground];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground:");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground:");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive:");
    [self.ui enteredForeground];
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
    [self.ui timeChanged];
}

@end
