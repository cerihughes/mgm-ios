
#import "MGMAlbumSelectionDelegate.h"
#import "MGMAlbumServiceType.h"

@import Foundation;
@import UIKit;

@class MGMAlbumPlayer;
@class MGMCore;
@class MGMImageHelper;
@class MGMNavigationController;

#define TO_ALBUM_DETAIL @"TO_ALBUM_DETAIL"

@interface MGMUI : NSObject <MGMAlbumSelectionDelegate, MGMPlaylistSelectionDelegate>

#if DEBUG
+ (void)setIpad:(BOOL)ipad;
#endif

@property (readonly) BOOL ipad;
@property (readonly) MGMCore* core;
@property (readonly) MGMNavigationController* mainController;
@property (readonly) MGMAlbumPlayer* albumPlayer;
@property (readonly) MGMImageHelper* imageHelper;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCore:(MGMCore *)core imageHelper:(MGMImageHelper *)imageHelper;

- (void) uiWillResignActive;
- (void) uiDidEnterBackground;
- (void) uiWillEnterForeground;
- (void) uiDidBecomeActive;

- (NSString*) labelForServiceType:(MGMAlbumServiceType)serviceType;
- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType;
- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
