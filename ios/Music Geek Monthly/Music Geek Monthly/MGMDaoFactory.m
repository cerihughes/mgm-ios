//
//  MGMDaoFactory.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDaoFactory.h"

@implementation MGMDaoFactory

- (id) init
{
    if (self = [super init])
    {
        [self createInstances];
    }
    return self;
}

- (void) createInstances
{
    self.lastFmDao = [[MGMLastFmDao alloc] init];
    self.spotifyDao = [[MGMSpotifyDao alloc] init];
    self.eventsDao = [[MGMEventsDao alloc] init];
}

- (MGMAlbumMetadataDao*) metadataDaoForServiceType:(MGMAlbumServiceType)serviceType
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeLastFm:
            return self.lastFmDao;
        case MGMAlbumServiceTypeSpotify:
            return self.spotifyDao;
        default:
            return nil;
    }
}

@end
