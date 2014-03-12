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
        NSError* error = nil;
        [self refreshAlbumMetadata:album error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error);
        });
    });
}

- (BOOL) refreshAlbumMetadata:(MGMAlbum*)album error:(NSError**)error
{
    if ([album metadataForServiceType:self.serviceType] == nil && [album searchedServiceType:self.serviceType] == NO)
    {
        MGMRemoteData* remoteData = [self fetchRemoteData:album];
        if (remoteData.error)
        {
            if (error)
            {
                *error = remoteData.error;
            }
            return NO;
        }
        else
        {
            MGMAlbumMetadataDto* metadata = remoteData.data;
            [self.coreDataAccess addMetadata:metadata toAlbum:album.objectID error:error];
            return MGM_NO_ERROR(&error);
        }
    }
    return YES;
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

- (NSString*) urlForPlaylist:(MGMPlaylist*)playlist
{
    // OVERRIDE
    return nil;
}

@end
