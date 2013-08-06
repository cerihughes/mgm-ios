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
#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&from=%d&to=%d&api_key=%@&format=json"
#define ALBUM_INFO_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=%@&mbid=%@&format=json"

#define GROUP_NAME @"Music+Geek+Monthly"
#define API_KEY @"a854bc0fca8c0d316751ed4ed2082379"

#define MAX_TIME_PERIODS 104

#define IMAGE_SIZE_SMALL @"small"
#define IMAGE_SIZE_MEDIUM @"medium"
#define IMAGE_SIZE_LARGE @"large"
#define IMAGE_SIZE_EXTRA_LARGE @"extralarge"
#define IMAGE_SIZE_MEGA @"mega"

@interface MGMLastFmDao ()

@property (strong) NSArray* sizeStrings;

@end

@implementation MGMLastFmDao

- (id) init
{
    if (self = [super init])
    {
        self.sizeStrings = @[IMAGE_SIZE_SMALL, IMAGE_SIZE_MEDIUM, IMAGE_SIZE_LARGE, IMAGE_SIZE_EXTRA_LARGE, IMAGE_SIZE_MEGA];
    }
    return self;
}

- (NSArray*) weeklyTimePeriods
{
    NSString* urlString = [NSString stringWithFormat:WEEKLY_PERIODS_URL, GROUP_NAME, API_KEY];
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (error == nil && jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            return [self timePeriodsForJson:json];
        }
    }
    return nil;
}

- (NSArray*) topWeeklyAlbums:(NSUInteger)count forTimePeriod:(MGMTimePeriod*)timePeriod
{
    NSUInteger from = timePeriod.startDate.timeIntervalSince1970;
    NSUInteger to = timePeriod.endDate.timeIntervalSince1970;
    NSString* urlString = [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, from, to, API_KEY];
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (error == nil && jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            return [self albums:count forJson:json];
        }
    }
    return nil;
}

- (NSArray*) topWeeklyAlbumsForMostRecentTimePeriod:(NSUInteger)count
{
    MGMTimePeriod* mostRecent = [[self weeklyTimePeriods] objectAtIndex:0];
    return [self topWeeklyAlbums:count forTimePeriod:mostRecent];
}

- (void) updateAlbumInfo:(MGMAlbum*)album
{
    NSString* urlString = [NSString stringWithFormat:ALBUM_INFO_URL, API_KEY, album.albumMbid];
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (error == nil && jsonData)
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
    NSDictionary* weeklychartlist = [json objectForKey:@"weeklychartlist"];
    NSArray* chart = [weeklychartlist objectForKey:@"chart"];
    NSArray* reversedChart = [self reverseArray:chart];
    NSUInteger cap = reversedChart.count < MAX_TIME_PERIODS ? reversedChart.count : MAX_TIME_PERIODS;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:cap];
    for (NSUInteger i = 0; i < cap; i++)
    {
        NSDictionary* period = [reversedChart objectAtIndex:i];
        NSUInteger from = [[period objectForKey:@"from"] intValue];
        NSUInteger to = [[period objectForKey:@"to"] intValue];
        NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:from];
        NSDate* toDate = [NSDate dateWithTimeIntervalSince1970:to];
        MGMTimePeriod* timePeriod = [MGMTimePeriod timePeriodWithStartDate:fromDate endDate:toDate];
        [results addObject:timePeriod];
    }

    return [results copy];
}

- (NSArray *)reverseArray:(NSArray*)array
{
    NSMutableArray* reversed = [NSMutableArray arrayWithCapacity:array.count];
    NSEnumerator* enumerator = array.reverseObjectEnumerator;
    for (id element in enumerator)
    {
        [reversed addObject:element];
    }
    return [reversed copy];
}

- (NSArray*) albums:(NSUInteger)count forJson:(NSDictionary*)json
{
    NSDictionary* weeklyalbumchart = [json objectForKey:@"weeklyalbumchart"];
    NSArray* albums = [weeklyalbumchart objectForKey:@"album"];
    NSUInteger cap = albums.count < count ? albums.count : count;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:cap];
    for (NSUInteger i = 0; i < cap; i++)
    {
        NSDictionary* album = [albums objectAtIndex:i];
        MGMGroupAlbum* converted = [self albumForJson:album];
        [results addObject:converted];
    }
    return [results copy];
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
    return album;
}

- (void) updateAlbumInfo:(MGMAlbum*)album withJson:(NSDictionary*)json
{
    NSDictionary* albumJson = [json objectForKey:@"album"];
    NSArray* images = [albumJson objectForKey:@"image"];
    for (NSDictionary* image in images)
    {
        NSString* key = [image objectForKey:@"size"];
        NSString* value = [image objectForKey:@"#text"];
        if (value && value.length > 0)
        {
            MGMAlbumImageSize size = [self.sizeStrings indexOfObject:key];
            if (size != NSNotFound)
            {
                [album setImageUrl:value forImageSize:size];
            }
        }
    }
}

@end
