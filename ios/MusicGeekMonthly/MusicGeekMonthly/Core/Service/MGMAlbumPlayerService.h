//
//  MGMAlbumPlayerService.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumService.h"

#import "MGMAlbum.h"

@interface MGMAlbumPlayerService : MGMAlbumService

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess NS_UNAVAILABLE;

- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess
                           serviceType:(MGMAlbumServiceType)serviceType;

@property (readonly) MGMAlbumServiceType serviceType;

- (NSString*) serviceAvailabilityUrl;
- (NSString*) urlForAlbum:(MGMAlbum*)album;
- (NSString*) urlForPlaylist:(NSString*)spotifyPlaylistId;

@end
