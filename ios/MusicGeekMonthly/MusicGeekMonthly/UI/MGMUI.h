
#import <Foundation/Foundation.h>

#import "MGMAlbumPlayer.h"
#import "MGMAlbumSelectionDelegate.h"
#import "MGMAlbumViewUtilities.h"
#import "MGMCore.h"
#import "MGMImageHelper.h"
#import "MGMNavigationViewController.h"

#define TO_ALBUM_DETAIL @"TO_ALBUM_DETAIL"

@interface MGMUI : NSObject <MGMAlbumSelectionDelegate, MGMPlaylistSelectionDelegate>

@property (readonly) BOOL ipad;
@property (readonly) MGMCore* core;
@property (readonly) MGMNavigationViewController* parentViewController;
@property (readonly) MGMAlbumPlayer* albumPlayer;
@property (readonly) MGMImageHelper* imageHelper;
@property (readonly) MGMAlbumViewUtilities* viewUtilities;

- (void) setReachability:(BOOL)reachability;

- (void) uiWillResignActive;
- (void) uiDidEnterBackground;
- (void) uiWillEnterForeground;
- (void) uiDidBecomeActive;

- (NSString*) labelForServiceType:(MGMAlbumServiceType)serviceType;
- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType;
- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
