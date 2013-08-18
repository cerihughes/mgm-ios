//
//  MGMLastFmDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMLastFmDao.h"

#import "MGMAlbumImageUriDto.h"
#import "MGMChartEntryDto.h"

#define WEEKLY_PERIODS_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyChartList&group=%@&api_key=%@&format=json"
#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&from=%d&to=%d&api_key=%@&format=json"
#define ALBUM_INFO_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=%@&mbid=%@&format=json"

#define GROUP_NAME @"Music+Geek+Monthly"
#define API_KEY @"a854bc0fca8c0d316751ed4ed2082379"

#define MAX_CHART_ENTRIES 50
#define MAX_TIME_PERIODS 104

#define IMAGE_SIZE_SMALL @"small"
#define IMAGE_SIZE_MEDIUM @"medium"
#define IMAGE_SIZE_LARGE @"large"
#define IMAGE_SIZE_EXTRA_LARGE @"extralarge"
#define IMAGE_SIZE_MEGA @"mega"

#define FAKE_MBID_PREPEND @"[MGMFAKEMBID]"

#define REFRESH_IDENTIFIER_ALL_TIME_PERIODS @"REFRESH_IDENTIFIER_ALL_TIME_PERIODS"
#define REFRESH_IDENTIFIER_WEEKLY_CHART @"REFRESH_IDENTIFIER_WEEKLY_CHART_%d_%d"

@interface MGMLastFmDao ()

@property (strong) NSArray* sizeStrings;
@property (strong) NSNumberFormatter* numberFormatter;

@end

@implementation MGMLastFmDao

- (id) init
{
    if (self = [super init])
    {
        self.sizeStrings = @[IMAGE_SIZE_SMALL, IMAGE_SIZE_MEDIUM, IMAGE_SIZE_LARGE, IMAGE_SIZE_EXTRA_LARGE, IMAGE_SIZE_MEGA];
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    }
    return self;
}

- (void) fetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    // TODO : THIS CAN ALL BE REFACTORED
    if ([self needsUrlRefresh:REFRESH_IDENTIFIER_ALL_TIME_PERIODS])
    {
        [self urlFetchAllTimePeriods:^(NSArray* events, NSError* error)
        {
            if (error == nil)
            {
                [self setNextUrlRefresh:REFRESH_IDENTIFIER_ALL_TIME_PERIODS inDays:1];
            }
            completion(events, error);
        }];
    }
    else
    {
        [self cdFetchAllTimePeriods:completion];
    }
}

- (void) urlFetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    NSString* urlString = [NSString stringWithFormat:WEEKLY_PERIODS_URL, GROUP_NAME, API_KEY];
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (jsonData)
    {
        NSError* jsonError = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
        if (jsonError == nil)
        {
            NSArray* array = [self timePeriodsForJson:json];
            [self.coreDataDao persistTimePeriods:array completion:^(NSError* persistError)
            {
                if (persistError == nil)
                {
                    [self cdFetchAllTimePeriods:completion];
                }
                else
                {
                    completion(nil, persistError);
                }
            }];
        }
        else
        {
            completion(nil, jsonError);
        }
    }
}

- (void) cdFetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    [self.coreDataDao fetchAllTimePeriods:completion];
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
        MGMTimePeriodDto* timePeriod = [[MGMTimePeriodDto alloc] init];
        timePeriod.startDate = fromDate;
        timePeriod.endDate = toDate;
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

- (void) fetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion
{
    // TODO : THIS CAN ALL BE REFACTORED
    NSUInteger from = startDate.timeIntervalSince1970;
    NSUInteger to = endDate.timeIntervalSince1970;
    NSString* identifier = [NSString stringWithFormat:REFRESH_IDENTIFIER_WEEKLY_CHART, from, to];

    if ([self needsUrlRefresh:identifier])
    {
        [self urlFetchWeeklyChartForStartDate:startDate endDate:endDate completion:^(MGMWeeklyChart* weeklyChart, NSError* error)
        {
            if (error == nil)
            {
                [self setNextUrlRefresh:identifier inDays:21];
            }
            completion(weeklyChart, error);
        }];
    }
    else
    {
        [self cdFetchWeeklyChartForStartDate:startDate endDate:endDate completion:completion];
    }

}

- (void) urlFetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion
{
    NSUInteger from = startDate.timeIntervalSince1970;
    NSUInteger to = endDate.timeIntervalSince1970;
    NSString* urlString = [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, from, to, API_KEY];
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (jsonData)
    {
        NSError* jsonError = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
        if (jsonError == nil)
        {
            MGMWeeklyChartDto* weeklyChart = [[MGMWeeklyChartDto alloc] init];
            weeklyChart.startDate = startDate;
            weeklyChart.endDate = endDate;

            NSDictionary* weeklyalbumchart = [json objectForKey:@"weeklyalbumchart"];
            NSArray* albums = [weeklyalbumchart objectForKey:@"album"];
            NSUInteger cap = albums.count < MAX_CHART_ENTRIES ? albums.count : MAX_CHART_ENTRIES;
            for (NSUInteger i = 0; i < cap; i++)
            {
                NSDictionary* album = [albums objectAtIndex:i];
                MGMChartEntryDto* converted = [self chartEntryForJson:album];
                [weeklyChart.chartEntries addObject:converted];
            }

            [self.coreDataDao persistWeeklyChart:weeklyChart completion:^(NSError* persistError)
            {
                if (persistError == nil)
                {
                    [self cdFetchWeeklyChartForStartDate:startDate endDate:endDate completion:completion];
                }
                else
                {
                    completion(nil, persistError);
                }
            }];
        }
        else
        {
            completion(nil, jsonError);
        }
    }
}

- (void) cdFetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion
{
    [self.coreDataDao fetchWeeklyChartWithStartDate:startDate endDate:endDate completion:completion];
}

- (MGMChartEntryDto*) chartEntryForJson:(NSDictionary*)json
{
    NSString* rankString = [[json objectForKey:@"@attr"] objectForKey:@"rank"];
    NSString* listenersString = [json objectForKey:@"playcount"];
    NSNumber* rank = [self.numberFormatter numberFromString:rankString];
    NSNumber* listeners = [self.numberFormatter numberFromString:listenersString];

    MGMChartEntryDto* chartEntry = [[MGMChartEntryDto alloc] init];
    chartEntry.rank = rank;
    chartEntry.listeners = listeners;
    chartEntry.album = [self albumForJson:json];

    return chartEntry;
}

- (MGMAlbumDto*) albumForJson:(NSDictionary*)json
{
    NSString* mbid = [json objectForKey:@"mbid"];
    NSDictionary* artist = [json objectForKey:@"artist"];
    NSString* artistName = [artist objectForKey:@"#text"];
    NSString* albumName = [json objectForKey:@"name"];

    if (mbid.length == 0)
    {
        mbid = [NSString stringWithFormat:@"%@[%@][%@]", FAKE_MBID_PREPEND, artistName, albumName];
    }

    MGMAlbumDto* album = [[MGMAlbumDto alloc] init];
    album.albumMbid = mbid;
    album.artistName = artistName;
    album.albumName = albumName;

    return album;
}

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion
{
    NSString* mbid = album.albumMbid;
    if ([mbid hasPrefix:FAKE_MBID_PREPEND])
    {
        // Can't yet get info on fake mbids - just mark are searched.
        [self.coreDataDao addImageUris:[NSArray array] toAlbumWithMbid:mbid updateServiceType:MGMAlbumServiceTypeLastFm completion:^(NSError* updateError)
        {
            completion(album, updateError);
        }];
    }
    else
    {
        NSString* urlString = [NSString stringWithFormat:ALBUM_INFO_URL, API_KEY, mbid];
        NSData* jsonData = [self contentsOfUrl:urlString];
        if (jsonData)
        {
            NSError* jsonError = nil;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
            if (jsonError == nil)
            {
                NSArray* imageUriDtos = [self imageUrisForJson:json];
                [self.coreDataDao addImageUris:imageUriDtos toAlbumWithMbid:mbid updateServiceType:MGMAlbumServiceTypeLastFm completion:^(NSError* updateError)
                {
                    if (updateError == nil)
                    {
                        [self.coreDataDao fetchAlbumWithMbid:mbid completion:completion];
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
}

- (NSArray*) imageUrisForJson:(NSDictionary*)json
{
    NSMutableArray* imageUris = [NSMutableArray array];
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
                MGMAlbumImageUriDto* imageUri = [[MGMAlbumImageUriDto alloc] init];
                imageUri.size = size;
                imageUri.uri = value;
                [imageUris addObject:imageUri];
            }
        }
    }

    return [imageUris copy];
}

@end
