
#import <Foundation/Foundation.h>

#import "MGMAlbumPlayer.h"
#import "MGMAlbumSelectionDelegate.h"
#import "MGMCore.h"
#import "MGMImageHelper.h"

#define TO_ALBUM_DETAIL @"TO_ALBUM_DETAIL"

@interface MGMUI : NSObject <MGMAlbumSelectionDelegate>

@property (readonly) BOOL ipad;
@property (retain) MGMCore* core;
@property (retain) UIViewController* parentViewController;
@property (strong) MGMAlbumPlayer* albumPlayer;

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

- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
