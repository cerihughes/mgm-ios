//
//  MGMAlbumPlayerService.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteJsonDataSource.h"

#import "MGMAlbum.h"
#import "MGMAlbumMetadataDto.h"
#import "MGMCoreDataAccess.h"
#import "MGMPlaylistDto.h"

@interface MGMAlbumPlayerService : MGMRemoteJsonDataSource

@property (readonly) MGMAlbumServiceType serviceType;

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (BOOL) refreshAlbumMetadata:(MGMAlbum*)album error:(NSError**)error;
- (NSString*) serviceAvailabilityUrl;
- (NSString*) urlForAlbum:(MGMAlbum*)album;
- (NSString*) urlForPlaylist:(MGMPlaylistDto*)playlist;

@end
