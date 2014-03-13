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
#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteJsonDataConverter.h"

@implementation MGMWeeklyChartData

@end

@implementation MGMWeeklyChartDaoOperation

#define REFRESH_IDENTIFIER_WEEKLY_CHART @"REFRESH_IDENTIFIER_WEEKLY_CHART_%lu_%lu"

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess*)coreDataAccess
{
    return [[MGMWeeklyChartLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
}

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMWeeklyChartRemoteDataSource alloc] init];
}

- (NSUInteger) daysBetweenRemoteFetch
{
    return 52 * 7;
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    MGMWeeklyChartData* data = key;
    NSUInteger from = data.startDate.timeIntervalSince1970;
    NSUInteger to = data.endDate.timeIntervalSince1970;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_WEEKLY_CHART, (unsigned long)from, (unsigned long)to];
}

@end

@implementation MGMWeeklyChartLocalDataSource

- (oneway void) fetchLocalData:(id)key completion:(LOCAL_DATA_FETCH_COMPLETION)completion
{
    MGMWeeklyChartData* data = key;
    [self.coreDataAccess fetchWeeklyChartWithStartDate:data.startDate endDate:data.endDate completion:^(NSManagedObjectID* moid, NSError* error) {
        MGMLocalData* localData = [[MGMLocalData alloc] init];
        localData.error = error;
        localData.data = moid;
        completion(localData);
    }];
}

- (oneway void) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key completion:(LOCAL_DATA_PERSIST_COMPLETION)completion
{
    [self.coreDataAccess persistWeeklyChart:remoteData.data completion:completion];
}

@end

@interface MGMWeeklyChartRemoteDataReader : MGMRemoteHttpDataReader

@end

@implementation MGMWeeklyChartRemoteDataReader

#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&from=%lu&to=%lu&api_key=%@&format=json"

- (NSString*) urlForKey:(id)key
{
    MGMWeeklyChartData* data = key;
    NSUInteger from = data.startDate.timeIntervalSince1970;
    NSUInteger to = data.endDate.timeIntervalSince1970;
    return [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, (unsigned long)from, (unsigned long)to, API_KEY];
}

@end

@interface MGMWeeklyChartRemoteDataConverter : MGMRemoteJsonDataConverter

@property (readonly) NSNumberFormatter* numberFormatter;

@end

@implementation MGMWeeklyChartRemoteDataConverter

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
        MGMWeeklyChartData* data = key;
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

@implementation MGMWeeklyChartRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    return [[MGMWeeklyChartRemoteDataReader alloc] init];
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    return [[MGMWeeklyChartRemoteDataConverter alloc] init];
}

@end
