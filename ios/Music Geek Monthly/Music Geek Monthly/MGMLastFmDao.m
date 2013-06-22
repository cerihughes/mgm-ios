//
//  MGMLastFmDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMLastFmDao.h"
#import "MGMGroupAlbum.h"

#define WEEKLY_PERIODS_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyChartList&group=%@&api_key=%@&format=json"
#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&api_key=%@&format=json"
#define ALBUM_INFO_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=%@&mbid=%@&format=json"

#define GROUP_NAME @"Music+Geek+Monthly"
#define API_KEY @"a854bc0fca8c0d316751ed4ed2082379"

#define MAX_RESULTS 15

@interface MGMLastFmDao()

@end

@implementation MGMLastFmDao

- (NSArray*) weeklyTimePeriods
{
    NSString* urlString = [NSString stringWithFormat:WEEKLY_PERIODS_URL, GROUP_NAME, API_KEY];
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (error == nil)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            return [self timePeriodsForJson:json];
        }
    }
    return nil;
}

- (MGMGroupAlbums*) topWeeklyAlbums
{
    NSString* urlString = [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, API_KEY];
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:urlString];
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

- (void) updateAlbumInfo:(MGMGroupAlbum*)album
{
    NSString* urlString = [NSString stringWithFormat:ALBUM_INFO_URL, API_KEY, album.albumMbid];
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (error == nil && jsonData != nil)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            [self updateAlbumInfo:album withJson:json];
        }
    }
}

- (NSArray*) timePeriodsForJson:(NSDictionary*)json
{
    NSMutableArray* array = [NSMutableArray array];
    NSDictionary* weeklychartlist = [json objectForKey:@"weeklychartlist"];
    NSArray* chart = [weeklychartlist objectForKey:@"chart"];
    for (NSDictionary* period in chart)
    {
        NSUInteger from = [[period objectForKey:@"from"] intValue];
        NSUInteger to = [[period objectForKey:@"to"] intValue];
        NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:from];
        NSDate* toDate = [NSDate dateWithTimeIntervalSince1970:to];
        MGMTimePeriod* timePeriod = [MGMTimePeriod timePeriodWithStartDate:fromDate endDate:toDate];
        [array addObject:timePeriod];
    }

    return [array copy];
}

- (MGMGroupAlbums*) albumsForJson:(NSDictionary*)json
{
    MGMGroupAlbums* groupAlbums = [[MGMGroupAlbums alloc] init];
    NSDictionary* weeklyalbumchart = [json objectForKey:@"weeklyalbumchart"];
    NSDictionary* attrs = [weeklyalbumchart objectForKey:@"@attr"];
    NSUInteger from = [[attrs objectForKey:@"from"] intValue];
    NSUInteger to = [[attrs objectForKey:@"to"] intValue];
    NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:from];
    NSDate* toDate = [NSDate dateWithTimeIntervalSince1970:to];
    NSArray* albums = [weeklyalbumchart objectForKey:@"album"];
    NSUInteger cap = albums.count < MAX_RESULTS ? albums.count : MAX_RESULTS;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:cap];
    for (NSUInteger i = 0; i < cap; i++)
    {
        NSDictionary* album = [albums objectAtIndex:i];
        MGMGroupAlbum* converted = [self albumForJson:album];
        [results addObject:converted];
    }
    groupAlbums.albums = [results copy];
    groupAlbums.timePeriod = [MGMTimePeriod timePeriodWithStartDate:fromDate endDate:toDate];
    return groupAlbums;
}

- (MGMGroupAlbum*) albumForJson:(NSDictionary*)json
{
    MGMGroupAlbum* album = [[MGMGroupAlbum alloc] init];
    NSUInteger rank = [[[json objectForKey:@"@attr"] objectForKey:@"rank"] intValue];
    NSDictionary* artist = [json objectForKey:@"artist"];
    NSString* artistMbid = [artist objectForKey:@"mbid"];
    NSString* artistName = [artist objectForKey:@"#text"];
    NSString* albumMbid = [json objectForKey:@"mbid"];
    NSString* albumName = [json objectForKey:@"name"];
    NSUInteger listeners = [[json objectForKey:@"playcount"] intValue];
    NSString* url = [json objectForKey:@"url"];

    album.rank = rank;
    album.artistMbid = artistMbid;
    album.artistName = artistName;
    album.albumMbid = albumMbid;
    album.albumName = albumName;
    album.listeners = listeners;
    album.lastFmUri = url;
    album.searchedLastFmData = NO;
    album.searchedSpotifyData = NO;
    return album;
}

- (void) updateAlbumInfo:(MGMGroupAlbum*)album withJson:(NSDictionary*)json
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
    album.searchedLastFmData = YES;
}

@end
