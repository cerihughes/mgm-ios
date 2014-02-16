
#import <Foundation/Foundation.h>

#import "MGMAlbumPlayer.h"
#import "MGMAlbumSelectionDelegate.h"
#import "MGMCore.h"
#import "MGMImageHelper.h"
#import "MGMAlbumViewUtilities.h"

#define TO_ALBUM_DETAIL @"TO_ALBUM_DETAIL"

@interface MGMUI : NSObject <MGMAlbumSelectionDelegate>

@property (readonly) BOOL ipad;
@property (readonly) MGMCore* core;
@property (readonly) UIViewController* parentViewController;
@property (readonly) MGMAlbumPlayer* albumPlayer;
@property (readonly) MGMImageHelper* imageHelper;
@property (readonly) MGMAlbumViewUtilities* viewUtilities;

- (void) start;
- (NSString*) labelForServiceType:(MGMAlbumServiceType)serviceType;
- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType;
- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
