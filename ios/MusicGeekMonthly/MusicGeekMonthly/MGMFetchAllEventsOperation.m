//
//  MGMFetchAllEventsOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchAllEventsOperation.h"

#import "MGMAlbumMetadataDto.h"

#define REFRESH_IDENTIFIER_ALL_EVENTS @"REFRESH_IDENTIFIER_ALL_EVENTS"
#define EVENTS_URL @"http://music-geek-monthly.appspot.com/json/events.json"

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

@implementation MGMFetchAllEventsOperation

- (NSString*) refreshIdentifierForData:(id)data
{
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_ALL_EVENTS];
}

- (NSString*) urlForData:(id)data
{
    return EVENTS_URL;
}

- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion
{
    completion([self eventsForJson:json], nil);
}

- (NSArray*) eventsForJson:(NSDictionary*)json
{
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

    return [results copy];
}

- (MGMAlbumDto*) albumForJson:(NSDictionary*)json
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

- (void) coreDataPersistConvertedData:(id)convertedUrlData withData:(id)data completion:(VOID_COMPLETION)completion
{
    [self.coreDataDao persistEvents:convertedUrlData completion:completion];
}

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    [self.coreDataDao fetchAllEvents:completion];
}

@end
