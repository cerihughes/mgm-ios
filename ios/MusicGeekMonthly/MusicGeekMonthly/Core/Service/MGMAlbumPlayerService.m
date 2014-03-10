//
//  MGMAlbumPlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumPlayerService.h"

@interface MGMAlbumPlayerService ()

@property (readonly) MGMCoreDataAccess* coreDataAccess;

@end

@implementation MGMAlbumPlayerService

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _coreDataAccess = coreDataAccess;
    }
    return self;
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
            [self.coreDataAccess addMetadata:metadata toAlbum:album error:error];
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
