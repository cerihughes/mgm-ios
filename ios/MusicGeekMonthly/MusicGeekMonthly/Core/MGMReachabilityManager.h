//
//  MGMReachabilityManager.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;

@protocol MGMReachabilityManagerListener <NSObject>

- (void) reachabilityDetermined:(BOOL)reachability;

@end

@interface MGMReachabilityManager : NSObject

- (void) addListener:(id<MGMReachabilityManagerListener>)listener;
- (void) removeListener:(id<MGMReachabilityManagerListener>)listener;
- (void) registerForReachabilityTo:(NSString*)url;

@end
