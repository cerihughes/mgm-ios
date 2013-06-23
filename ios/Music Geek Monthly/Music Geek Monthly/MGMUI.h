
#import <Foundation/Foundation.h>
#import "MGMCore.h"
#import "MGMTransitionViewController.h"
#import "MGMImageCache.h"

#define TO_CHART @"TO_CHART"
#define TO_PLAYLISTS @"TO_PLAYLISTS"

@interface MGMUI : NSObject

@property (retain) MGMCore* core;
@property (retain) MGMTransitionViewController* parentViewController;
@property (retain) MGMImageCache* imageCache;

- (void) transition:(NSString*)transition;
- (void) transition:(NSString*)transition withState:(id)state;

/**
 * Notifies the UI that it's entering background mode.
 */
- (void) enteringBackground;

/**
 * Notifies the UI that it's entered foreground mode.
 */
- (void) enteredForeground;

/**
 * Notifies the UI when the time changes "considerably" (e.g. at midnight, at daylight savings or manual / carrier-based system time changes.
 */
- (void) timeChanged;

@end
