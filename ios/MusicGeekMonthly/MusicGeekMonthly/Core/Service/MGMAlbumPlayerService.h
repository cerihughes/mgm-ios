//
//  MGMAlbumPlayerService.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

#import "MGMAlbum.h"
#import "MGMAlbumMetadataDto.h"
#import "MGMCoreDataAccess.h"
#import "MGMPlaylist.h"

@interface MGMAlbumPlayerService : MGMRemoteDataSource

@property (readonly) MGMAlbumServiceType serviceType;

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (BOOL) refreshAlbumMetadata:(MGMAlbum*)album error:(NSError**)error;
- (NSString*) serviceAvailabilityUrl;
- (NSString*) urlForAlbum:(MGMAlbum*)album;
- (NSString*) urlForPlaylist:(MGMPlaylist*)playlist;

@end
