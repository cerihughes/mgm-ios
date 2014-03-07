
#import <Foundation/Foundation.h>

#import "MGMAlbumPlayer.h"
#import "MGMAlbumSelectionDelegate.h"
#import "MGMAlbumViewUtilities.h"
#import "MGMCore.h"
#import "MGMImageHelper.h"
#import "MGMTabBarController.h"

#define TO_ALBUM_DETAIL @"TO_ALBUM_DETAIL"

@interface MGMUI : NSObject <MGMAlbumSelectionDelegate, MGMPlaylistSelectionDelegate>

@property (readonly) BOOL ipad;
@property (readonly) MGMCore* core;
@property (readonly) MGMTabBarController* parentViewController;
@property (readonly) MGMAlbumPlayer* albumPlayer;
@property (readonly) MGMImageHelper* imageHelper;
@property (readonly) MGMAlbumViewUtilities* viewUtilities;

- (void) uiWillResignActive;
- (void) uiDidEnterBackground;
- (void) uiWillEnterForeground;
- (void) uiDidBecomeActive;

- (NSString*) labelForServiceType:(MGMAlbumServiceType)serviceType;
- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType;
- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
