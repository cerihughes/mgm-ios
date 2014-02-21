//
//  MGMAllEventsDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAllEventsDaoOperation.h"

#import "MGMLastFmConstants.h"
#import "MGMEventDto.h"

@implementation MGMAllEventsDaoOperation

#define REFRESH_IDENTIFIER_ALL_EVENTS @"REFRESH_IDENTIFIER_ALL_EVENTS"

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    MGMLocalDataSource* localDataSource = [[MGMAllEventsLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
    MGMRemoteDataSource* remoteDataSource = [[MGMAllEventsRemoteDataSource alloc] init];
    return [super initWithCoreDataAccess:coreDataAccess localDataSource:localDataSource remoteDataSource:remoteDataSource daysBetweenRemoteFetch:1];
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    return REFRESH_IDENTIFIER_ALL_EVENTS;
}

@end

@implementation MGMAllEventsLocalDataSource

- (MGMLocalData*) fetchLocalData:(id)key
{
    MGMLocalData* localData = [[MGMLocalData alloc] init];
    NSError* error = nil;
    if ([key isEqualToString:ALL_EVENTS_KEY])
    {
        localData.data = [self.coreDataAccess fetchAllEvents:&error];
    }
    else if ([key isEqualToString:ALL_CLASSIC_ALBUMS_KEY])
    {
        localData.data = [self.coreDataAccess fetchAllClassicAlbums:&error];
    }
    else if ([key isEqualToString:ALL_NEWLY_RELEASED_ALBUMS_KEY])
    {
        localData.data = [self.coreDataAccess fetchAllNewlyReleasedAlbums:&error];
    }
    else if ([key isEqualToString:ALL_EVENT_ALBUMS_KEY])
    {
        localData.data = [self.coreDataAccess fetchAllEventAlbums:&error];
    }
    localData.error = error;
    return localData;
}

- (BOOL) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key error:(NSError**)error
{
    return [self.coreDataAccess persistEvents:remoteData.data error:error];
}

@end

@implementation MGMAllEventsRemoteDataSource

#define EVENTS_URL @"http://music-geek-monthly.appspot.com/json/events.json"

#define JSON_ELEMENT_LAST_UPDATE @"lastUpdate"
#define JSON_ELEMENT_EVENTS @"events"
#define JSON_ELEMENT_ID @"id"
#define JSON_ELEMENT_DATE @"date"
#define JSON_ELEMENT_PLAYLIST_ID @"spotifyPlaylistId"
#define JSON_ELEMENT_CLASSIC_ALBUM @"classicAlbum"
#define JSON_ELEMENT_NEW_ALBUM @"newAlbum"
#define JSON_ELEMENT_ARTIST_NAME @"artistName"
#define JSON_ELEMENT_ALBUM_NAME @"albumName"
#define JSON_ELEMENT_MBID @"mbid"
#define JSON_ELEMENT_SCORE @"score"
#define JSON_ELEMENT_METADATA @"metadata"

#define METADATA_KEY_LASTFM @"lastFm"
#define METADATA_KEY_SPOTIFY @"spotify"
#define METADATA_KEY_WIKIPEDIA @"wikipedia"
#define METADATA_KEY_YOUTUBE @"youtube"
#define METADATA_KEY_ITUNES @"itunes"
#define METADATA_KEY_DEEZER @"deezer"

- (NSString*) urlForKey:(id)key
{
    return EVENTS_URL;
}

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
{
    NSString* lastUpdate = [json objectForKey:JSON_ELEMENT_LAST_UPDATE];
    NSArray* events = [json objectForKey:JSON_ELEMENT_EVENTS];
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:events.count];
    for (NSUInteger i = 0; i < events.count; i++)
    {
        NSDictionary* eventJson = [events objectAtIndex:i];
        NSNumber* eventNumber = [eventJson objectForKey:JSON_ELEMENT_ID];
        NSString* dateString = [eventJson objectForKey:JSON_ELEMENT_DATE];
        NSDate* date = [self dateForJsonString:dateString];
        NSString* playlistId = [eventJson objectForKey:JSON_ELEMENT_PLAYLIST_ID];

        MGMAlbumDto* classicAlbum = [self albumForJson:[eventJson objectForKey:JSON_ELEMENT_CLASSIC_ALBUM]];
        MGMAlbumDto* newAlbum = [self albumForJson:[eventJson objectForKey:JSON_ELEMENT_NEW_ALBUM]];

        MGMEventDto* event = [[MGMEventDto alloc] init];
        event.eventNumber = eventNumber;
        event.eventDate = date;
        event.spotifyPlaylistId = playlistId;
        event.classicAlbum = classicAlbum;
        event.newlyReleasedAlbum = newAlbum;

        [results addObject:event];
    }

    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = [results copy];
    remoteData.checksum = lastUpdate;
    return remoteData;
}

- (MGMAlbumDto*) albumForJson:(NSDictionary*)json
{
    if (json)
    {
        NSString* artistName = [json objectForKey:JSON_ELEMENT_ARTIST_NAME];
        NSString* albumName = [json objectForKey:JSON_ELEMENT_ALBUM_NAME];
        NSString* mbid = [json objectForKey:JSON_ELEMENT_MBID];
        NSNumber* score = [json objectForKey:JSON_ELEMENT_SCORE];
        NSDictionary* metadata = [json objectForKey:JSON_ELEMENT_METADATA];
        if (metadata == nil)
        {
            metadata = [NSDictionary dictionary];
        }

        MGMAlbumDto* album = [[MGMAlbumDto alloc] init];
        album.artistName = artistName;
        album.albumName = albumName;
        album.albumMbid = mbid;
        album.score = score;

        [metadata enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL *stop)
         {
             MGMAlbumServiceType serviceType = [self serviceTypeForString:key];
             if (serviceType != MGMAlbumServiceTypeNone)
             {
                 MGMAlbumMetadataDto* metadata = [[MGMAlbumMetadataDto alloc] init];
                 metadata.serviceType = serviceType;
                 metadata.value = obj;
                 [album.metadata addObject:metadata];
             }
         }];

        MGMAlbumMetadataDto* lastfmMetadata = [[MGMAlbumMetadataDto alloc] init];
        lastfmMetadata.serviceType = MGMAlbumServiceTypeLastFm;
        lastfmMetadata.value = artistName;
        [album.metadata addObject:lastfmMetadata];

        return album;
    }
    return nil;
}

- (MGMAlbumServiceType) serviceTypeForString:(NSString*)string
{
    if ([string isEqualToString:METADATA_KEY_LASTFM])
    {
        return MGMAlbumServiceTypeLastFm;
    }
    if ([string isEqualToString:METADATA_KEY_SPOTIFY])
    {
        return MGMAlbumServiceTypeSpotify;
    }
    if ([string isEqualToString:METADATA_KEY_WIKIPEDIA])
    {
        return MGMAlbumServiceTypeWikipedia;
    }
    if ([string isEqualToString:METADATA_KEY_YOUTUBE])
    {
        return MGMAlbumServiceTypeYouTube;
    }
    if ([string isEqualToString:METADATA_KEY_ITUNES])
    {
        return MGMAlbumServiceTypeItunes;
    }
    if ([string isEqualToString:METADATA_KEY_DEEZER])
    {
        return MGMAlbumServiceTypeDeezer;
    }
    return MGMAlbumServiceTypeNone;
}

@end
