
#import <Foundation/Foundation.h>

#import "MGMAlbumPlayer.h"
#import "MGMAlbumSelectionDelegate.h"
#import "MGMCore.h"
#import "MGMImageHelper.h"
#import "MGMNavigationController.h"

#define TO_ALBUM_DETAIL @"TO_ALBUM_DETAIL"

@interface MGMUI : NSObject <MGMAlbumSelectionDelegate, MGMPlaylistSelectionDelegate>

@property (readonly) BOOL ipad;
@property (readonly) MGMCore* core;
@property (readonly) MGMNavigationController* parentViewController;
@property (readonly) MGMAlbumPlayer* albumPlayer;
@property (readonly) MGMImageHelper* imageHelper;

- (void) uiWillResignActive;
- (void) uiDidEnterBackground;
- (void) uiWillEnterForeground;
- (void) uiDidBecomeActive;

- (NSString*) labelForServiceType:(MGMAlbumServiceType)serviceType;
- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType;
- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
