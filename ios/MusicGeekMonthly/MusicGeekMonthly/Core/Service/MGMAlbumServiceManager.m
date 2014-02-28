//
//  MGMAlbumServiceManager.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumServiceManager.h"

#import "MGMLastFmPlayerService.h"
#import "MGMSpotifyPlayerService.h"
#import "MGMWebsitePlayerService.h"

@interface MGMAlbumServiceManager ()

@property (readonly) MGMLastFmPlayerService* lastFmService;
@property (readonly) MGMSpotifyPlayerService* spotifyService;
@property (readonly) MGMWebsitePlayerService* deezerService;
@property (readonly) MGMWebsitePlayerService* itunesService;
@property (readonly) MGMWebsitePlayerService* wikipediaService;
@property (readonly) MGMWebsitePlayerService* youtubeService;
@property (readonly) NSArray* allServices;

@end

@implementation MGMAlbumServiceManager

#define ALBUM_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/%@"
#define SEARCH_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/index.php?search=%@ %@"
#define ALBUM_PATTERN_YOUTUBE @"http://www.youtube.com/watch?v=%@"
#define SEARCH_PATTERN_YOUTUBE @"http://www.youtube.com/results?search_query=%@ %@"
#define ALBUM_PATTERN_ITUNES @"https://itunes.apple.com/gb/album/%@?uo=4"
#define ALBUM_PATTERN_DEEZER @"deezer://www.deezer.com/album/%@"
#define SEARCH_PATTERN_DEEZER @"deezer-query://www.deezer.com/album/?query=%@ %@"

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _lastFmService = [[MGMLastFmPlayerService alloc] initWithCoreDataAccess:coreDataAccess];
        _spotifyService = [[MGMSpotifyPlayerService alloc] initWithCoreDataAccess:coreDataAccess];
        _deezerService = [[MGMWebsitePlayerService alloc] initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess albumUrlPattern:ALBUM_PATTERN_DEEZER searchUrlPattern:SEARCH_PATTERN_DEEZER serviceType:MGMAlbumServiceTypeDeezer];
        _itunesService = [[MGMWebsitePlayerService alloc] initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess albumUrlPattern:ALBUM_PATTERN_ITUNES searchUrlPattern:nil serviceType:MGMAlbumServiceTypeItunes];
        _wikipediaService = [[MGMWebsitePlayerService alloc] initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess albumUrlPattern:ALBUM_PATTERN_WIKIPEDIA searchUrlPattern:SEARCH_PATTERN_WIKIPEDIA serviceType:MGMAlbumServiceTypeWikipedia];
        _youtubeService = [[MGMWebsitePlayerService alloc] initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess albumUrlPattern:ALBUM_PATTERN_WIKIPEDIA searchUrlPattern:SEARCH_PATTERN_YOUTUBE serviceType:MGMAlbumServiceTypeYouTube];
        _allServices = @[_lastFmService, _spotifyService, _deezerService, _itunesService, _wikipediaService, _youtubeService];
    }
    return self;
}

- (void) setReachability:(BOOL)reachability
{
    self.lastFmService.reachability = reachability;
    self.spotifyService.reachability = reachability;
    self.deezerService.reachability = reachability;
    self.itunesService.reachability = reachability;
    self.wikipediaService.reachability = reachability;
    self.youtubeService.reachability = reachability;
}

- (NSUInteger) serviceTypesThatPlayAlbum:(MGMAlbum*)album
{
    NSUInteger metadataServiceTypes = 0;
    for (MGMAlbumPlayerService* service in self.allServices)
    {
        NSString* urlString = [service urlForAlbum:album];
        if (urlString)
        {
            MGMAlbumServiceType serviceType = service.serviceType;
            metadataServiceTypes |= serviceType;
        }
    }
    return metadataServiceTypes;
}

- (MGMAlbumPlayerService*) playerServiceForServiceType:(MGMAlbumServiceType)serviceType
{
    for (MGMAlbumPlayerService* service in self.allServices)
    {
        if (service.serviceType == serviceType)
        {
            return service;
        }
    }
    return nil;
}

- (NSString*) serviceAvailabilityUrlForServiceType:(MGMAlbumServiceType)serviceType
{
    MGMAlbumPlayerService* service = [self playerServiceForServiceType:serviceType];
    return [service serviceAvailabilityUrl];
}

- (NSString*) urlForAlbum:(MGMAlbum*)album forServiceType:(MGMAlbumServiceType)serviceType
{
    MGMAlbumPlayerService* service = [self playerServiceForServiceType:serviceType];
    return [service urlForAlbum:album];
}

- (NSString*) urlForPlaylist:(MGMPlaylist*)playlist forServiceType:(MGMAlbumServiceType)serviceType
{
    MGMAlbumPlayerService* service = [self playerServiceForServiceType:serviceType];
    return [service urlForPlaylist:playlist];
}

- (BOOL) refreshAlbumMetadata:(MGMAlbum*)album forServiceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
{
    MGMAlbumPlayerService* service = [self playerServiceForServiceType:serviceType];
    return [service refreshAlbumMetadata:album error:error];
}

@end