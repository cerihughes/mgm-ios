//
//  MGMDaoFactory.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDaoFactory.h"

#define ALBUM_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/%@"
#define SEARCH_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/index.php?search=%@ %@"
#define ALBUM_PATTERN_YOUTUBE @"http://www.youtube.com/watch?v=%@"
#define SEARCH_PATTERN_YOUTUBE @"http://www.youtube.com/results?search_query=%@ %@"
#define ALBUM_PATTERN_ITUNES @"https://itunes.apple.com/gb/album/%@?uo=4"
#define ALBUM_PATTERN_DEEZER @"deezer://www.deezer.com/album/%@"
#define SEARCH_PATTERN_DEEZER @"deezer-query://www.deezer.com/album/?query=%@ %@"

@interface MGMDaoFactory ()

@property (strong) MGMCoreDataDao* coreDataDao;
@property (strong) MGMLastFmDao* lastFmDao;
@property (strong) MGMSpotifyDao* spotifyDao;
@property (strong) MGMEventsDao* eventsDao;
@property (strong) MGMSettingsDao* settingsDao;
@property (strong) MGMWebsiteAlbumMetadataDao* deezerDao;
@property (strong) MGMWebsiteAlbumMetadataDao* itunesDao;
@property (strong) MGMWebsiteAlbumMetadataDao* wikipediaDao;
@property (strong) MGMWebsiteAlbumMetadataDao* youtubeDao;
@property (strong) NSArray* albumMetadataDaos;

@end

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
    self.settingsDao = [[MGMSettingsDao alloc] init];
    self.deezerDao = [[MGMWebsiteAlbumMetadataDao alloc] initWithCoreDataDao:self.coreDataDao reachabilityManager:reachabilityManager albumUrlPattern:ALBUM_PATTERN_DEEZER searchUrlPattern:SEARCH_PATTERN_DEEZER serviceType:MGMAlbumServiceTypeDeezer];
    self.itunesDao = [[MGMWebsiteAlbumMetadataDao alloc] initWithCoreDataDao:self.coreDataDao reachabilityManager:reachabilityManager albumUrlPattern:ALBUM_PATTERN_ITUNES searchUrlPattern:nil serviceType:MGMAlbumServiceTypeItunes];
    self.wikipediaDao = [[MGMWebsiteAlbumMetadataDao alloc] initWithCoreDataDao:self.coreDataDao reachabilityManager:reachabilityManager albumUrlPattern:ALBUM_PATTERN_WIKIPEDIA searchUrlPattern:SEARCH_PATTERN_WIKIPEDIA serviceType:MGMAlbumServiceTypeWikipedia];
    self.youtubeDao = [[MGMWebsiteAlbumMetadataDao alloc] initWithCoreDataDao:self.coreDataDao reachabilityManager:reachabilityManager albumUrlPattern:ALBUM_PATTERN_WIKIPEDIA searchUrlPattern:SEARCH_PATTERN_YOUTUBE serviceType:MGMAlbumServiceTypeYouTube];
    self.albumMetadataDaos = @[self.lastFmDao, self.spotifyDao, self.deezerDao, self.itunesDao, self.wikipediaDao, self.youtubeDao];
}

- (MGMAlbumMetadataDao*) metadataDaoForServiceType:(MGMAlbumServiceType)serviceType
{
    for (MGMAlbumMetadataDao* metadataDao in self.albumMetadataDaos)
    {
        if (metadataDao.serviceType == serviceType)
        {
            return metadataDao;
        }
    }
    return nil;
}

- (NSUInteger) serviceTypesThatPlayAlbum:(MGMAlbum*)album
{
    NSUInteger metadataServiceTypes = 0;
    for (MGMAlbumMetadataDao* metadataDao in self.albumMetadataDaos)
    {
        NSString* urlString = [metadataDao urlForAlbum:album];
        if (urlString)
        {
            MGMAlbumServiceType serviceType = metadataDao.serviceType;
            metadataServiceTypes |= serviceType;
        }
    }
    return metadataServiceTypes;
}

@end
