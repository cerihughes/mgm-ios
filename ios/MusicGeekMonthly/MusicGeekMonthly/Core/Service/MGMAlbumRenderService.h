//
//  MGMAlbumRenderService.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

#import "MGMAlbum.h"
#import "MGMCoreDataAccess.h"

@interface MGMAlbumRenderService : MGMRemoteDataSource

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (BOOL) refreshAlbumImages:(MGMAlbum*)album error:(NSError**)error;

@end
