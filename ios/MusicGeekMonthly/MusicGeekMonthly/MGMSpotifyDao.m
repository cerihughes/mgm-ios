//
//  MGMSpotifyDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyDao.h"

#import "MGMFetchSpotifyAlbumMetadataOperation.h"

@interface MGMSpotifyDao ()

@property (strong) MGMFetchSpotifyAlbumMetadataOperation* fetchSpotifyAlbumMetadataOperation;

@end

@implementation MGMSpotifyDao

- (id) initWithCoreDataDao:(MGMCoreDataDao *)coreDataDao
{
    if (self = [super initWithCoreDataDao:coreDataDao])
    {
        self.fetchSpotifyAlbumMetadataOperation = [[MGMFetchSpotifyAlbumMetadataOperation alloc] init];
    }
    return self;
}

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion
{
    [self.fetchSpotifyAlbumMetadataOperation executeWithData:album completion:completion];
}

@end
