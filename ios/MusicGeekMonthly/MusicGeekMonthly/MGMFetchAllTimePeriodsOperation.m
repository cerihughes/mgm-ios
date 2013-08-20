//
//  MGMFetchAllTimePeriodsOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchAllTimePeriodsOperation.h"

#import "MGMLastFmConstants.h"

#define REFRESH_IDENTIFIER_ALL_TIME_PERIODS @"REFRESH_IDENTIFIER_ALL_TIME_PERIODS"
#define TIME_PERIODS_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyChartList&group=%@&api_key=%@&format=json"
#define MAX_TIME_PERIODS 104

@implementation MGMFetchAllTimePeriodsOperation

- (NSString*) refreshIdentifierForData:(id)data
{
    return REFRESH_IDENTIFIER_ALL_TIME_PERIODS;
}

- (NSString*) urlForData:(id)data
{
    return [NSString stringWithFormat:TIME_PERIODS_URL, GROUP_NAME, API_KEY];
}

- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion
{
    completion([self timePeriodsForJson:json], nil);
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

- (void) coreDataPersistConvertedData:(id)convertedUrlData withData:(id)data completion:(VOID_COMPLETION)completion
{
    [self.coreDataDao persistTimePeriods:convertedUrlData completion:completion];
}

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    [self.coreDataDao fetchAllTimePeriods:completion];
}

@end
