//
//  MGMEventsDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsDao.h"
#import "MGMEvent.h"
#import "MGMAlbum.h"

#define EVENTS_URL @"http://music-geek-monthly.appspot.com/json/events.json"
#define MAX_EVENTS 12

#define JSON_ELEMENT_EVENTS @"events"
#define JSON_ELEMENT_ID @"id"
#define JSON_ELEMENT_DATE @"date"
#define JSON_ELEMENT_PLAYLIST_ID @"spotifyPlaylistId"
#define JSON_ELEMENT_CLASSIC_ALBUM @"classicAlbum"
#define JSON_ELEMENT_NEW_ALBUM @"newAlbum"
#define JSON_ELEMENT_ARTIST_NAME @"artistName"
#define JSON_ELEMENT_ALBUM_NAME @"albumName"
#define JSON_ELEMENT_MBID @"mbid"
#define JSON_ELEMENT_ALBUM_ID @"spotifyAlbumId"

@interface MGMEventsDao ()

@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMEventsDao

- (id) init
{
    if (self = [super init])
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    }
    return self;
}

- (NSArray*) events
{
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:EVENTS_URL];
    if (error == nil)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            return [self eventsForJson:json];
        }
    }
    return nil;
}

- (NSArray*) eventsForJson:(NSDictionary*)json
{
    NSArray* events = [json objectForKey:JSON_ELEMENT_EVENTS];
    NSUInteger cap = events.count < MAX_EVENTS ? events.count : MAX_EVENTS;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:cap];
    for (NSUInteger i = 0; i < cap; i++)
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
    NSString* spotifyAlbumId = [json objectForKey:JSON_ELEMENT_ALBUM_ID];

    MGMAlbum* album = [[MGMAlbum alloc] init];
    album.artistName = artistName;
    album.albumName = albumName;
    album.albumMbid = mbid;
    album.spotifyAlbumId = spotifyAlbumId;

    return album;
}

@end
