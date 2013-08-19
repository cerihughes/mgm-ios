//
//  MGMReachabilityManager.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMReachabilityManager.h"

#import <SystemConfiguration/SCNetworkReachability.h>

typedef enum
{
	MGMReachabilityManagerConnectivityNone,
	MGMReachabilityManagerConnectivityWifi,
	MGMReachabilityManagerConnectivityWwan
}
MGMReachabilityManagerConnectivity;

@interface MGMReachabilityManager()

@property MGMReachabilityManagerConnectivity connectivity;
@property (retain) NSMutableArray* listeners;

- (void) networkReachabilityFlagsChanged:(SCNetworkReachabilityFlags)flags forTarget:(SCNetworkReachabilityRef)target;

@end

static void networkReachabilityCallBack(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
	MGMReachabilityManager* instance = (__bridge MGMReachabilityManager *)(info);
	[instance networkReachabilityFlagsChanged:flags forTarget:target];
}

@implementation MGMReachabilityManager
{
    SCNetworkReachabilityContext _proxyReachabilityContext;
}

- (id) init
{
    if (self = [super init])
    {
        self.connectivity = MGMReachabilityManagerConnectivityNone;
        self.listeners = [NSMutableArray array];
    }
    return self;
}

- (void) addListener:(id<MGMReachabilityManagerListener>)listener
{
    [self.listeners addObject:listener];
}

- (void) removeListener:(id<MGMReachabilityManagerListener>)listener
{
    [self.listeners removeObject:listener];
}

- (void) informListenersOfReachability:(BOOL)reachability
{
    for (id<MGMReachabilityManagerListener> listener in self.listeners)
    {
        [listener reachabilityDetermined:reachability];
    }
}

- (void) registerForReachabilityTo:(NSString *)url
{
    SCNetworkReachabilityRef proxyReachability = SCNetworkReachabilityCreateWithName(NULL, [url cStringUsingEncoding:NSUTF8StringEncoding]);
    if (proxyReachability != nil)
    {
        SCNetworkReachabilityFlags reachabilityFlags;
        // If reachability information is available now, we don't get notification until it changes.
        if (SCNetworkReachabilityGetFlags (proxyReachability, &reachabilityFlags))
        {
            networkReachabilityCallBack(proxyReachability, reachabilityFlags, (__bridge void *)(self));
        }

        _proxyReachabilityContext.info = (__bridge void *)(self);
        SCNetworkReachabilitySetCallback(proxyReachability, (SCNetworkReachabilityCallBack)networkReachabilityCallBack, &_proxyReachabilityContext);
        SCNetworkReachabilityScheduleWithRunLoop(proxyReachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void) logNetworkFlags:(SCNetworkReachabilityFlags)flags {
	NSString* string;
	if (flags == 0) {
		string = @" None";
	} else {
		string = @"";
		if (flags & kSCNetworkReachabilityFlagsTransientConnection) {
			string = [string stringByAppendingString:@" TransientConnection"];
		}
		if (flags & kSCNetworkReachabilityFlagsReachable) {
			string = [string stringByAppendingString:@" Reachable"];
		}
		if (flags & kSCNetworkReachabilityFlagsConnectionRequired) {
			string = [string stringByAppendingString:@" ConnectionRequired"];
		}
		if (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) {
			string = [string stringByAppendingString:@" ConnectionOnTraffic"];
		}
		if (flags & kSCNetworkReachabilityFlagsInterventionRequired) {
			string = [string stringByAppendingString:@" InterventionRequired"];
		}
		if (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) {
			string = [string stringByAppendingString:@" ConnectionOnDemand"];
		}
		if (flags & kSCNetworkReachabilityFlagsIsLocalAddress) {
			string = [string stringByAppendingString:@" IsLocalAddress"];
		}
		if (flags & kSCNetworkReachabilityFlagsIsDirect) {
			string = [string stringByAppendingString:@" IsDirect"];
		}
		if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
			string = [string stringByAppendingString:@" IsWWAN"];
		}
	}
	NSLog(@"Reachability callback - Network connection flags:%@", string);
}

- (void) networkReachabilityFlagsChanged:(SCNetworkReachabilityFlags)flags forTarget:(SCNetworkReachabilityRef)target
{
    MGMReachabilityManagerConnectivity nwc;
    [self logNetworkFlags:flags];

    if ((flags == 0) | (flags & (kSCNetworkReachabilityFlagsConnectionRequired |kSCNetworkReachabilityFlagsConnectionOnTraffic)))
    {
        nwc = MGMReachabilityManagerConnectivityNone;
    }
    else
    {
        nwc = flags & kSCNetworkReachabilityFlagsIsWWAN ? MGMReachabilityManagerConnectivityWwan : MGMReachabilityManagerConnectivityWifi;
    }

    NSLog(@"Reachability: %@", (nwc == MGMReachabilityManagerConnectivityNone) ? @"none" : (nwc == MGMReachabilityManagerConnectivityWifi) ? @"wifi" : @"wwan");

    if (self.connectivity != nwc)
    {
        [self informListenersOfReachability:NO];
        if (nwc != MGMReachabilityManagerConnectivityNone)
        {
            [self informListenersOfReachability:YES];
        }
    }
    self.connectivity = nwc;
}

@end

