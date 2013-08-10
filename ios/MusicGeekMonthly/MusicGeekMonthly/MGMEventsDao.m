//
//  MGMEventsDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsDao.h"
#import "MGMAlbum.h"

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

- (MGMEvent*) latestEvent
{
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:EVENTS_URL];
    if (error == nil && jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            NSArray* array = [self eventsForJson:json cap:1];
            return [array objectAtIndex:0];
        }
    }
    return nil;
}

- (NSArray*) events
{
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:EVENTS_URL];
    if (error == nil && jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            return [self eventsForJson:json cap:0];
        }
    }
    return nil;
}

- (NSArray*) eventsForJson:(NSDictionary*)json cap:(NSUInteger)cap
{
    NSArray* events = [json objectForKey:JSON_ELEMENT_EVENTS];
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:events.count];
    NSUInteger capped = cap > 0 ? (cap < events.count ? cap : events.count) : events.count;
    for (NSUInteger i = 0; i < capped; i++)
    {
        NSDictionary* eventJson = [events objectAtIndex:i];
        NSUInteger eventNumber = [[eventJson objectForKey:JSON_ELEMENT_ID] intValue];
        NSString* dateString = [eventJson objectForKey:JSON_ELEMENT_DATE];
        NSDate* date = [self.dateFormatter dateFromString:dateString];
        NSString* playlistId = [eventJson objectForKey:JSON_ELEMENT_PLAYLIST_ID];
        MGMAlbum* classicAlbum = [self albumForJson:[eventJson objectForKey:JSON_ELEMENT_CLASSIC_ALBUM]];
        MGMAlbum* newAlbum = [self albumForJson:[eventJson objectForKey:JSON_ELEMENT_NEW_ALBUM]];

        MGMEvent* event = [[MGMEvent alloc] init];
        event.eventNumber = eventNumber;
        event.eventDate = date;
        event.spotifyPlaylistId = playlistId;
        event.classicAlbum = classicAlbum;
        event.newlyReleasedAlbum = newAlbum;

        [results addObject:event];
    }

    return [results copy];
}

- (MGMAlbum*) albumForJson:(NSDictionary*)json
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

    MGMAlbum* album = [[MGMAlbum alloc] init];
    album.artistName = artistName;
    album.albumName = albumName;
    album.albumMbid = mbid;
    album.score = score;
    [metadata enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL *stop)
    {
        MGMAlbumServiceType serviceType = [self.serviceTypes indexOfObject:key];
        if (serviceType != NSNotFound)
        {
            [album setMetadata:obj forServiceType:serviceType];
        }
    }];

    return album;
}

@end
