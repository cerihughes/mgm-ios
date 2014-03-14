//
//  MGMAlbumPlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumPlayerService.h"

@implementation MGMAlbumPlayerService

- (void) refreshAlbum:(MGMAlbum*)album completion:(ALBUM_SERVICE_COMPLETION)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self refreshAlbumMetadata:album completion:^(NSError* error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }];
    });
}

- (oneway void) refreshAlbumMetadata:(MGMAlbum*)album completion:(ALBUM_SERVICE_COMPLETION)completion
{
    if ([album metadataForServiceType:self.serviceType] == nil && [album searchedServiceType:self.serviceType] == NO)
    {
        [self fetchRemoteData:album completion:^(MGMRemoteData* remoteData) {
            if (remoteData.error)
            {
                completion(remoteData.error);
            }
            else
            {
                MGMAlbumMetadataDto* metadata = remoteData.data;
                [self.coreDataAccess addMetadata:metadata toAlbum:album.objectID completion:^(NSError* addError) {
                    [self.coreDataAccess mainThreadRefresh:album];
                    completion(addError);
                }];
            }
        }];
    }
    else
    {
        completion(nil);
    }
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

- (NSString*) urlForPlaylist:(NSString*)spotifyPlaylistId
{
    // OVERRIDE
    return nil;
}

@end
