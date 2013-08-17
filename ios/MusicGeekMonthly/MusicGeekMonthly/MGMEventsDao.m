//
//  MGMEventsDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsDao.h"

#import "MGMAlbum.h"
#import "MGMAlbumMetadataDto.h"

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

@interface MGMEventsDao ()

@property (strong) NSArray* serviceTypes;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMEventsDao

- (id) init
{
    if (self = [super init])
    {
        self.serviceTypes = @[METADATA_KEY_LASTFM, METADATA_KEY_SPOTIFY, METADATA_KEY_WIKIPEDIA, METADATA_KEY_YOUTUBE];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    }
    return self;
}

- (void) fetchLatestEvent:(FETCH_COMPLETION)completion
{
    NSData* jsonData = [self contentsOfUrl:EVENTS_URL];
    if (jsonData)
    {
        NSError* jsonError = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
        if (jsonError == nil)
        {
            NSArray* array = [self eventsForJson:json cap:1];
            MGMEventDto* event = [array objectAtIndex:0];
            [self.coreDataDao persistEvents:array completion:^(NSError* updateError)
            {
                if (updateError == nil)
                {
                    [self.coreDataDao fetchEventWithEventNumber:event.eventNumber completion:completion];
                }
                else
                {
                    completion(nil, updateError);
                }
            }];
        }
        else
        {
            completion(nil, jsonError);
        }
    }
}

- (void) fetchAllEvents:(FETCH_MANY_COMPLETION)completion
{
    NSData* jsonData = [self contentsOfUrl:EVENTS_URL];
    if (jsonData)
    {
        NSError* jsonError = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
        if (jsonError == nil)
        {
            NSArray* events = [self eventsForJson:json cap:0];
            [self.coreDataDao persistEvents:events completion:^(NSError* updateError)
            {
                if (updateError == nil)
                {
                    [self.coreDataDao fetchAllEvents:completion];
                }
                else
                {
                    completion(nil, updateError);
                }
            }];
        }
        else
        {
            completion(nil, jsonError);
        }
    }
}

- (NSArray*) eventsForJson:(NSDictionary*)json cap:(NSUInteger)cap
{
    NSArray* events = [json objectForKey:JSON_ELEMENT_EVENTS];
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:events.count];
    NSUInteger capped = cap > 0 ? (cap < events.count ? cap : events.count) : events.count;
    for (NSUInteger i = 0; i < capped; i++)
    {
        NSDictionary* eventJson = [events objectAtIndex:i];
        NSNumber* eventNumber = [eventJson objectForKey:JSON_ELEMENT_ID];
        NSString* dateString = [eventJson objectForKey:JSON_ELEMENT_DATE];
        NSDate* date = [self.dateFormatter dateFromString:dateString];
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
        MGMAlbumServiceType serviceType = [self.serviceTypes indexOfObject:key];
        if (serviceType != NSNotFound)
        {
            MGMAlbumMetadataDto* metadata = [[MGMAlbumMetadataDto alloc] init];
            metadata.serviceType = serviceType;
            metadata.value = obj;
            [album.metadata addObject:metadata];
        }
    }];

    return album;
}

@end
