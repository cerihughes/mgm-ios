//
//  MGMWebsitePlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMWebsitePlayerService.h"

@interface MGMWebsitePlayerService ()

@property (copy) NSString* albumUrlPattern;
@property (copy) NSString* searchUrlPattern;

@end

@implementation MGMWebsitePlayerService

- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
                           serviceType:(MGMAlbumServiceType)serviceType
                       albumUrlPattern:(NSString*)albumUrlPattern
                      searchUrlPattern:(NSString*)searchUrlPattern
{
    self = [super initWithCoreDataAccess:coreDataAccess serviceType:serviceType];
    _albumUrlPattern = albumUrlPattern;
    _searchUrlPattern = searchUrlPattern;
    return self;
}

- (NSString*) serviceAvailabilityUrl
{
    return self.albumUrlPattern;
}

- (NSString*) urlForAlbum:(MGMAlbum*)album
{
    NSString* metadata = [album metadataForServiceType:self.serviceType];
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
