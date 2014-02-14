//
//  MGMAlbumMetadataDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumMetadataDao.h"

@implementation MGMAlbumMetadataDao

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion
{
    // OVERRIDE
    completion(nil, nil);
}

- (NSString*) serviceAvailabilityUrl
{
    // OVERRIDE
    return nil;
}

- (NSString*) urlForAlbum:(MGMAlbum*)album
{
    // OVERRIDE
    return nil;
}

@end
