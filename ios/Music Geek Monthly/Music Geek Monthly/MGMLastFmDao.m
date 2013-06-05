//
//  MGMLastFmDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMLastFmDao.h"
#import "MGMLastFmGroupAlbum.h"

#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&api_key=%@&format=json"
#define ALBUM_INFO_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=%@&mbid=%@&format=json"

#define GROUP_NAME @"Music+Geek+Monthly"
#define API_KEY @"a854bc0fca8c0d316751ed4ed2082379"

#define MAX_RESULTS 20

#define IMAGE_SIZE_PREFERENCE @[@"

@interface MGMLastFmDao()

@end

@implementation MGMLastFmDao

- (NSArray*) topWeeklyAlbums
{
    NSString* urlString = [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, API_KEY];
    NSURL* url = [NSURL URLWithString:urlString];
    NSError* error = nil;
    NSData* jsonData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error == nil)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            return [self albumsForJson:json];
        }
    }
    return nil;
}

- (void) updateAlbumInfo:(MGMLastFmGroupAlbum*)album
{
    NSString* urlString = [NSString stringWithFormat:ALBUM_INFO_URL, API_KEY, album.mbid];
    NSURL* url = [NSURL URLWithString:urlString];
    NSError* error = nil;
    NSData* jsonData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error == nil)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            [self updateAlbum:album withJson:json];
        }
    }
}

- (NSArray*) albumsForJson:(NSDictionary*)json
{
    NSDictionary* weeklyalbumchart = [json objectForKey:@"weeklyalbumchart"];
    NSArray* albums = [weeklyalbumchart objectForKey:@"album"];
    NSUInteger cap = albums.count < MAX_RESULTS ? albums.count : MAX_RESULTS;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:cap];
    for (NSUInteger i = 0; i < cap; i++)
    {
        NSDictionary* album = [albums objectAtIndex:i];
        MGMLastFmGroupAlbum* converted = [self albumForJson:album];
        [results addObject:converted];
    }
    return [results copy];
}

- (MGMLastFmGroupAlbum*) albumForJson:(NSDictionary*)json
{
    MGMLastFmGroupAlbum* album = [[MGMLastFmGroupAlbum alloc] init];
    NSUInteger rank = [[[json objectForKey:@"@attr"] objectForKey:@"rank"] intValue];
    NSString* artistName = [[json objectForKey:@"artist"] objectForKey:@"#text"];
    NSString* mbid = [json objectForKey:@"mbid"];
    NSString* albumName = [json objectForKey:@"name"];
    NSUInteger listeners = [[json objectForKey:@"playcount"] intValue];
    NSString* url = [json objectForKey:@"url"];

    album.rank = rank;
    album.artistName = artistName;
    album.mbid = mbid;
    album.albumName = albumName;
    album.listeners = listeners;
    album.lastFmUri = url;
    return album;
}

- (void) updateAlbum:(MGMLastFmGroupAlbum*)album withJson:(NSDictionary*)json
{
    NSDictionary* albumJson = [json objectForKey:@"album"];
    NSArray* images = [albumJson objectForKey:@"image"];
    NSMutableDictionary* modelImages = [NSMutableDictionary dictionaryWithCapacity:images.count];
    for (NSDictionary* image in images)
    {
        NSString* key = [image objectForKey:@"size"];
        NSString* value = [image objectForKey:@"#text"];
        [modelImages setObject:value forKey:key];
    }
    album.imageUris = [modelImages copy];
}

@end
