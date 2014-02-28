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

- (BOOL) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)serviceType error:(NSError**)error;
- (BOOL) playPlaylist:(MGMPlaylist*)playlist onService:(MGMAlbumServiceType)serviceType error:(NSError**)error;

@end
