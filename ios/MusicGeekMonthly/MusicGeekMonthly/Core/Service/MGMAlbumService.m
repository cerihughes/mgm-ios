//
//  MGMAlbumService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumService.h"

@implementation MGMAlbumService

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _coreDataAccess = coreDataAccess;
    }
    return self;
}

- (void) refreshAlbum:(MGMAlbum*)album completion:(ALBUM_SERVICE_COMPLETION)completion
{
    // OVERRIDE
}

@end
