
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

- (void) start;
- (NSString*) labelForServiceType:(MGMAlbumServiceType)serviceType;
- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType;
- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
