
#import <Foundation/Foundation.h>

#import "MGMAlbumPlayer.h"
#import "MGMCore.h"
#import "MGMImageHelper.h"
#import "MGMTransitionViewController.h"

#define TO_HOME @"TO_HOME"
#define TO_CHART @"TO_CHART"
#define TO_PLAYLISTS @"TO_PLAYLISTS"
#define TO_WEB @"TO_WEB"

@interface MGMUI : NSObject

@property (retain) MGMCore* core;
@property (retain) UIViewController* parentViewController;
@property (strong) MGMAlbumPlayer* albumPlayer;

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

- (void) handleError:(NSError*)error;

@end
