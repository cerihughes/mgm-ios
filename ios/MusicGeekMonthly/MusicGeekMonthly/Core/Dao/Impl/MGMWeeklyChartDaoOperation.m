//
//  MGMWeeklyChartDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartDaoOperation.h"

#import "MGMAlbumMetadataDto.h"
#import "MGMChartEntryDto.h"
#import "MGMErrorCodes.h"
#import "MGMLastFmConstants.h"

@implementation MGMFetchWeeklyChartData

@end

@implementation MGMWeeklyChartDaoOperation

#define REFRESH_IDENTIFIER_WEEKLY_CHART @"REFRESH_IDENTIFIER_WEEKLY_CHART_%lu_%lu"

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    MGMLocalDataSource* localDataSource = [[MGMWeeklyChartLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
    MGMRemoteDataSource* remoteDataSource = [[MGMWeeklyChartRemoteDataSource alloc] init];
    return [super initWithCoreDataAccess:coreDataAccess localDataSource:localDataSource remoteDataSource:remoteDataSource daysBetweenRemoteFetch:52*7];
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    MGMFetchWeeklyChartData* data = key;
    NSUInteger from = data.startDate.timeIntervalSince1970;
    NSUInteger to = data.endDate.timeIntervalSince1970;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_WEEKLY_CHART, (unsigned long)from, (unsigned long)to];
}

@end

@implementation MGMWeeklyChartLocalDataSource

- (MGMLocalData*) fetchLocalData:(id)key
{
    MGMFetchWeeklyChartData* data = key;

    MGMLocalData* localData = [[MGMLocalData alloc] init];
    NSError* error = nil;
    localData.data = [self.coreDataAccess fetchWeeklyChartWithStartDate:data.startDate endDate:data.endDate error:&error];
    localData.error = error;
    return localData;
}

- (BOOL) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key error:(NSError**)error
{
    return [self.coreDataAccess persistWeeklyChart:remoteData.data error:error];
}

@end

@interface MGMWeeklyChartRemoteDataSource ()

@property (readonly) NSNumberFormatter* numberFormatter;

@end

@implementation MGMWeeklyChartRemoteDataSource

#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&from=%lu&to=%lu&api_key=%@&format=json"
#define MAX_CHART_ENTRIES 50

- (id) init
{
    if (self = [super init])
    {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    }
    return self;
}

- (NSString*) urlForKey:(id)key
{
    MGMFetchWeeklyChartData* data = key;
    NSUInteger from = data.startDate.timeIntervalSince1970;
    NSUInteger to = data.endDate.timeIntervalSince1970;
    return [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, (unsigned long)from, (unsigned long)to, API_KEY];
}

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
{
    id errorValue = [json objectForKey:@"error"];
    if (errorValue != nil)
    {
        NSString* message = [json objectForKey:@"message"];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_LAST_FM_ERROR userInfo:userInfo];
        return [MGMRemoteData dataWithError:error];
    }
    else
    {
        MGMFetchWeeklyChartData* data = key;
        MGMWeeklyChartDto* weeklyChart = [[MGMWeeklyChartDto alloc] init];
        weeklyChart.startDate = data.startDate;
        weeklyChart.endDate = data.endDate;

        NSDictionary* weeklyalbumchart = [json objectForKey:@"weeklyalbumchart"];
        NSArray* albums = [weeklyalbumchart objectForKey:@"album"];
        NSUInteger cap = albums.count < MAX_CHART_ENTRIES ? albums.count : MAX_CHART_ENTRIES;
        for (NSUInteger i = 0; i < cap; i++)
        {
            NSDictionary* album = [albums objectAtIndex:i];
            MGMChartEntryDto* converted = [self chartEntryForJson:album];
            [weeklyChart.chartEntries addObject:converted];
        }

        MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
        remoteData.data = weeklyChart;
        remoteData.checksum = @"THIS WILL NEVER CHANGE";
        return remoteData;
    }
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

    MGMAlbumMetadataDto* lastfmMetadata = [[MGMAlbumMetadataDto alloc] init];
    lastfmMetadata.serviceType = MGMAlbumServiceTypeLastFm;
    lastfmMetadata.value = artistName;
    [album.metadata addObject:lastfmMetadata];

    return album;
}

@end
