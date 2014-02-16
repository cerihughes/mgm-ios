//
//  MGMWebsitePlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMWebsitePlayerService.h"

@interface MGMWebsitePlayerService ()

@property MGMAlbumServiceType internalServiceType;
@property (copy) NSString* albumUrlPattern;
@property (copy) NSString* searchUrlPattern;

@end

@implementation MGMWebsitePlayerService

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess albumUrlPattern:(NSString*)albumUrlPattern searchUrlPattern:(NSString*)searchUrlPattern serviceType:(MGMAlbumServiceType)serviceType
{
    if (self = [super initWithCoreDataAccess:coreDataAccess])
    {
        self.albumUrlPattern = albumUrlPattern;
        self.searchUrlPattern = searchUrlPattern;
        self.internalServiceType = serviceType;
    }
    return self;
}

- (MGMAlbumServiceType) serviceType
{
    return self.internalServiceType;
}

- (NSString*) serviceAvailabilityUrl
{
    return self.albumUrlPattern;
}

- (NSString*) urlForAlbum:(MGMAlbum*)album
{
    NSString* metadata = [album metadataForServiceType:self.internalServiceType];
    if (metadata)
    {
        return [NSString stringWithFormat:self.albumUrlPattern, metadata];
    }

    if (self.searchUrlPattern)
    {
        return [NSString stringWithFormat:self.searchUrlPattern, album.artistName, album.albumName];
    }

    return nil;
}

@end
