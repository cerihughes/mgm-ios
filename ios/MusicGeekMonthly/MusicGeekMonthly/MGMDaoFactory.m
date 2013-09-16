//
//  MGMDaoFactory.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDaoFactory.h"

@implementation MGMDaoFactory

- (id) initWithReachabilityManager:(MGMReachabilityManager*)reachabilityManager
{
    if (self = [super init])
    {
        [self createInstances:reachabilityManager];
    }
    return self;
}

- (void) createInstances:(MGMReachabilityManager*)reachabilityManager
{
    self.coreDataDao = [[MGMCoreDataDao alloc] init];
    self.lastFmDao = [[MGMLastFmDao alloc] initWithCoreDataDao:self.coreDataDao reachabilityManager:reachabilityManager];
    self.spotifyDao = [[MGMSpotifyDao alloc] initWithCoreDataDao:self.coreDataDao reachabilityManager:reachabilityManager];
    self.eventsDao = [[MGMEventsDao alloc] initWithCoreDataDao:self.coreDataDao reachabilityManager:reachabilityManager];
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
