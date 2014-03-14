//
//  MGMAlbumServiceManager.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbum.h"
#import "MGMAlbumService.h"
#import "MGMCoreDataAccess.h"

@interface MGMAlbumServiceManager : NSObject

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (void) setReachability:(BOOL)reachability;

- (NSUInteger) serviceTypesThatPlayAlbum:(MGMAlbum*)album;
- (NSString*) serviceAvailabilityUrlForServiceType:(MGMAlbumServiceType)serviceType;
- (NSString*) urlForAlbum:(MGMAlbum*)album forServiceType:(MGMAlbumServiceType)serviceType;
- (NSString*) urlForPlaylist:(NSString*)spotifyPlaylistId forServiceType:(MGMAlbumServiceType)serviceType;
- (void) refreshAlbum:(MGMAlbum*)album forServiceType:(MGMAlbumServiceType)serviceType completion:(ALBUM_SERVICE_COMPLETION)completion;

@end
