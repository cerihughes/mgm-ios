//
//  MGMFetchWeeklyChartOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchWeeklyChartOperation.h"

#import "MGMAlbumMetadataDto.h"
#import "MGMChartEntryDto.h"
#import "MGMErrorCodes.h"
#import "MGMLastFmConstants.h"

#define REFRESH_IDENTIFIER_WEEKLY_CHART @"REFRESH_IDENTIFIER_WEEKLY_CHART_%lu_%lu"
#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&from=%lu&to=%lu&api_key=%@&format=json"
#define MAX_CHART_ENTRIES 50

@implementation MGMFetchWeeklyChartOperationData

@end

@implementation MGMFetchWeeklyChartOperation

static NSNumberFormatter* numberFormatter;

+ (void) initialize
{
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
}

- (NSString*) refreshIdentifierForData:(id)data
{
    MGMFetchWeeklyChartOperationData* fetchData = data;
    NSUInteger from = fetchData.startDate.timeIntervalSince1970;
    NSUInteger to = fetchData.endDate.timeIntervalSince1970;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_WEEKLY_CHART, (unsigned long)from, (unsigned long)to];
}

- (NSString*) urlForData:(id)data
{
    MGMFetchWeeklyChartOperationData* fetchData = data;
    NSUInteger from = fetchData.startDate.timeIntervalSince1970;
    NSUInteger to = fetchData.endDate.timeIntervalSince1970;
    return [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, (unsigned long)from, (unsigned long)to, API_KEY];
}

- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion
{
    id errorValue = [json objectForKey:@"error"];
    if (errorValue != nil)
    {
        NSString* message = [json objectForKey:@"message"];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_LAST_FM_ERROR userInfo:userInfo];
        completion(nil, error);
    }
    else
    {
        MGMFetchWeeklyChartOperationData* fetchData = data;
        MGMWeeklyChartDto* weeklyChart = [[MGMWeeklyChartDto alloc] init];
        weeklyChart.startDate = fetchData.startDate;
        weeklyChart.endDate = fetchData.endDate;

        NSDictionary* weeklyalbumchart = [json objectForKey:@"weeklyalbumchart"];
        NSArray* albums = [weeklyalbumchart objectForKey:@"album"];
        NSUInteger cap = albums.count < MAX_CHART_ENTRIES ? albums.count : MAX_CHART_ENTRIES;
        for (NSUInteger i = 0; i < cap; i++)
        {
            NSDictionary* album = [albums objectAtIndex:i];
            MGMChartEntryDto* converted = [self chartEntryForJson:album];
            [weeklyChart.chartEntries addObject:converted];
        }
        completion(weeklyChart, nil);
    }
}

- (MGMChartEntryDto*) chartEntryForJson:(NSDictionary*)json
{
    NSString* rankString = [[json objectForKey:@"@attr"] objectForKey:@"rank"];
    NSString* listenersString = [json objectForKey:@"playcount"];
    NSNumber* rank = [numberFormatter numberFromString:rankString];
    NSNumber* listeners = [numberFormatter numberFromString:listenersString];

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

    MGMAlbumMetadataDto* lastfmMetadata = [[MGMAlbumMetadataDto alloc] init];
    lastfmMetadata.serviceType = MGMAlbumServiceTypeLastFm;
    lastfmMetadata.value = artistName;
    [album.metadata addObject:lastfmMetadata];

    return album;
}

- (void) coreDataPersistConvertedData:(id)convertedUrlData withData:(id)data completion:(VOID_COMPLETION)completion
{
    [self.coreDataDao persistWeeklyChart:convertedUrlData completion:completion];
}

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    MGMFetchWeeklyChartOperationData* fetchData = data;
    [self.coreDataDao fetchWeeklyChartWithStartDate:fetchData.startDate endDate:fetchData.endDate completion:completion];
}

@end
