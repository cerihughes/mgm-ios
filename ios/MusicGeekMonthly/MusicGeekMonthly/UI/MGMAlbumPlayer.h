//
//  MGMAlbumPlayer.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbumServiceManager.h"
#import "MGMAlbum.h"
#import "MGMPlaylist.h"

@class MGMUI;

@interface MGMAlbumPlayer : NSObject

@property (weak) MGMUI* ui;
@property (strong) MGMAlbumServiceManager* serviceManager;

- (NSUInteger) determineCapabilities;

- (void) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)serviceType completion:(ALBUM_SERVICE_COMPLETION)completion;
- (void) playPlaylist:(MGMPlaylist*)playlist onService:(MGMAlbumServiceType)serviceType completion:(ALBUM_SERVICE_COMPLETION)completion;

@end
