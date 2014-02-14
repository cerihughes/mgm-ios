//
//  MGMSpotifyDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyDao.h"

#import "MGMFetchSpotifyAlbumMetadataOperation.h"

#define ALBUM_URI @"spotify:album:%@"
#define SEARCH_URI @"spotify:search:%@ %@"

@interface MGMSpotifyDao ()

@property (strong) MGMFetchSpotifyAlbumMetadataOperation* fetchSpotifyAlbumMetadataOperation;

@end

@implementation MGMSpotifyDao

- (id) initWithCoreDataDao:(MGMCoreDataDao*)coreDataDao reachabilityManager:(MGMReachabilityManager*)reachabilityManager
{
    if (self = [super initWithCoreDataDao:coreDataDao reachabilityManager:reachabilityManager])
    {
        self.fetchSpotifyAlbumMetadataOperation = [[MGMFetchSpotifyAlbumMetadataOperation alloc] initWithCoreDataDao:coreDataDao reachabilityManager:reachabilityManager daysBetweenUrlFetch:0];
    }
    return self;
}

- (MGMAlbumServiceType) serviceType
{
    return MGMAlbumServiceTypeSpotify;
}

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion
{
    [self.fetchSpotifyAlbumMetadataOperation executeWithData:album completion:completion];
}

- (NSString*) serviceAvailabilityUrl
{
    return ALBUM_URI;
}

- (NSString*) urlForAlbum:(MGMAlbum*)album
{
    NSString* metadata = [album metadataForServiceType:MGMAlbumServiceTypeSpotify];
    if (metadata)
    {
        return [NSString stringWithFormat:ALBUM_URI, metadata];
    }
    else
    {
        return [NSString stringWithFormat:SEARCH_URI, album.artistName, album.albumName];
    }
}

@end
