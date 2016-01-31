//
//  MGMAllTimePeriodsDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAllTimePeriodsDaoOperation.h"

#import "MGMLastFmConstants.h"
#import "MGMSecrets.h"
#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteJsonDataConverter.h"
#import "MGMTimePeriodDto.h"

@implementation MGMAllTimePeriodsDaoOperation

#define REFRESH_IDENTIFIER_ALL_TIME_PERIODS @"REFRESH_IDENTIFIER_ALL_TIME_PERIODS"

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess*)coreDataAccess
{
    return [[MGMAllTimePeriodsLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
}

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMAllTimePeriodsRemoteDataSource alloc] init];
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    return REFRESH_IDENTIFIER_ALL_TIME_PERIODS;
}

@end

@implementation MGMAllTimePeriodsLocalDataSource

- (oneway void) fetchLocalData:(id)key completion:(LOCAL_DATA_FETCH_COMPLETION)completion
{
    [self.coreDataAccess fetchAllTimePeriods:^(NSArray* moids, NSError* error) {
        MGMLocalData* localData = [[MGMLocalData alloc] init];
        localData.error = error;
        localData.data = moids;
        completion(localData);
    }];
}

- (oneway void) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key completion:(LOCAL_DATA_PERSIST_COMPLETION)completion
{
    [self.coreDataAccess persistTimePeriods:remoteData.data completion:completion];
}

@end

@interface MGMAllTimePeriodsRemoteDataConverter : MGMRemoteJsonDataConverter

@end

@implementation MGMAllTimePeriodsRemoteDataConverter

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
{
    NSDictionary* weeklychartlist = [json objectForKey:@"weeklychartlist"];
    NSArray* chart = [weeklychartlist objectForKey:@"chart"];
    NSArray* reversedChart = [self reverseArray:chart];
    NSUInteger cap = reversedChart.count < MAX_TIME_PERIODS ? reversedChart.count : MAX_TIME_PERIODS;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:cap];

    // Keep these outside the loop so that the last values we process are available at the end of the loop. We'll use these as the checksum.
    NSUInteger from = 0;
    NSUInteger to = 0;

    for (NSUInteger i = 0; i < cap; i++)
    {
        NSDictionary* period = [reversedChart objectAtIndex:i];
        from = [[period objectForKey:@"from"] intValue];
        to = [[period objectForKey:@"to"] intValue];
        NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:from];
        NSDate* toDate = [NSDate dateWithTimeIntervalSince1970:to];
        MGMTimePeriodDto* timePeriod = [[MGMTimePeriodDto alloc] init];
        timePeriod.startDate = fromDate;
        timePeriod.endDate = toDate;
        [results addObject:timePeriod];
    }

    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = [results copy];
    remoteData.checksum = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)from, (unsigned long)to];
    return remoteData;
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

@end

@interface MGMAllTimePeriodsRemoteDataSource () <MGMRemoteHttpDataReaderDataSource>

@end

@implementation MGMAllTimePeriodsRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    MGMRemoteHttpDataReader *reader = [[MGMRemoteHttpDataReader alloc] init];
    reader.dataSource = self;
    return reader;
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    return [[MGMAllTimePeriodsRemoteDataConverter alloc] init];
}

#pragma mark - MGMRemoteHttpDataReaderDataSource

#define TIME_PERIODS_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyChartList&group=%@&api_key=%@&format=json"

- (NSString*) urlForKey:(id)key
{
    return [NSString stringWithFormat:TIME_PERIODS_URL, GROUP_NAME, LAST_FM_API_KEY];
}


@end
