//
//  MGMAlbumServiceManager.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumServiceManager.h"

#import "MGMItunesPlayerService.h"
#import "MGMLastFmPlayerService.h"
#import "MGMSpotifyPlayerService.h"
#import "MGMWebsitePlayerService.h"

@interface MGMAlbumServiceManager ()

@property (readonly) MGMLastFmPlayerService *lastFmService;
@property (readonly) MGMSpotifyPlayerService *spotifyService;
@property (readonly) MGMWebsitePlayerService *deezerService;
@property (readonly) MGMItunesPlayerService *itunesService;
@property (readonly) MGMWebsitePlayerService *wikipediaService;
@property (readonly) MGMWebsitePlayerService *youtubeService;
@property (readonly) NSArray<MGMAlbumPlayerService *> *allServices;

@end

@implementation MGMAlbumServiceManager

#define ALBUM_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/%@"
#define SEARCH_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/index.php?search=%@ %@"
#define ALBUM_PATTERN_YOUTUBE @"http://www.youtube.com/watch?v=%@"
#define SEARCH_PATTERN_YOUTUBE @"http://www.youtube.com/results?search_query=%@ %@"
#define ALBUM_PATTERN_DEEZER @"deezer://www.deezer.com/album/%@"
#define SEARCH_PATTERN_DEEZER @"deezer-query://www.deezer.com/album/?query=%@ %@"

- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    self = [super init];
    _lastFmService = [[MGMLastFmPlayerService alloc] initWithCoreDataAccess:coreDataAccess serviceType:MGMAlbumServiceTypeLastFm];
    _spotifyService = [[MGMSpotifyPlayerService alloc] initWithCoreDataAccess:coreDataAccess serviceType:MGMAlbumServiceTypeSpotify];
    _deezerService = [[MGMWebsitePlayerService alloc] initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess serviceType:MGMAlbumServiceTypeDeezer albumUrlPattern:ALBUM_PATTERN_DEEZER searchUrlPattern:SEARCH_PATTERN_DEEZER];
    _itunesService = [[MGMItunesPlayerService alloc] initWithCoreDataAccess:coreDataAccess serviceType:MGMAlbumServiceTypeItunes];
    _wikipediaService = [[MGMWebsitePlayerService alloc] initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess serviceType:MGMAlbumServiceTypeWikipedia albumUrlPattern:ALBUM_PATTERN_WIKIPEDIA searchUrlPattern:SEARCH_PATTERN_WIKIPEDIA];
    _youtubeService = [[MGMWebsitePlayerService alloc] initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess serviceType:MGMAlbumServiceTypeYouTube albumUrlPattern:ALBUM_PATTERN_YOUTUBE searchUrlPattern:SEARCH_PATTERN_YOUTUBE];
    _allServices = @[_lastFmService, _spotifyService, _deezerService, _itunesService, _wikipediaService, _youtubeService];
    return self;
}

- (void)setReachability:(BOOL)reachability
{
    for (MGMAlbumPlayerService *service in self.allServices) {
        [service setReachability:reachability];
    }
}

- (NSUInteger)serviceTypesThatPlayAlbum:(MGMAlbum*)album
{
    NSUInteger metadataServiceTypes = 0;
    for (MGMAlbumPlayerService* service in self.allServices) {
        NSString* urlString = [service urlForAlbum:album];
        if (urlString) {
            MGMAlbumServiceType serviceType = service.serviceType;
            metadataServiceTypes |= serviceType;
        }
    }
    return metadataServiceTypes |= MGMAlbumServiceTypeItunes;
}

- (MGMAlbumPlayerService*) playerServiceForServiceType:(MGMAlbumServiceType)serviceType
{
    for (MGMAlbumPlayerService* service in self.allServices) {
        if (service.serviceType == serviceType) {
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

- (NSString*) urlForPlaylist:(NSString*)spotifyPlaylistId forServiceType:(MGMAlbumServiceType)serviceType
{
    MGMAlbumPlayerService* service = [self playerServiceForServiceType:serviceType];
    return [service urlForPlaylist:spotifyPlaylistId];
}

- (void) refreshAlbum:(MGMAlbum*)album forServiceType:(MGMAlbumServiceType)serviceType completion:(ALBUM_SERVICE_COMPLETION)completion
{
    MGMAlbumPlayerService* service = [self playerServiceForServiceType:serviceType];
    [service refreshAlbum:album completion:completion];
}

@end