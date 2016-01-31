//
//  MGMAlbumService.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

#import "MGMCoreDataAccess.h"

typedef void (^ALBUM_SERVICE_COMPLETION) (NSError*);

@interface MGMAlbumService : MGMRemoteDataSource

@property (readonly) MGMCoreDataAccess* coreDataAccess;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess;

- (void) refreshAlbum:(MGMAlbum*)album completion:(ALBUM_SERVICE_COMPLETION)completion;

@end
