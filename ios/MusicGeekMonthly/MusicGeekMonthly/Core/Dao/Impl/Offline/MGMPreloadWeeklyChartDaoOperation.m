//
//  MGMPreloadWeeklyChartDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPreloadWeeklyChartDaoOperation.h"

#import "MGMRemoteFileDataReader.h"

@interface MGMPreloadWeeklyChartRemoteDataReader : MGMRemoteFileDataReader

@end

@implementation MGMPreloadWeeklyChartRemoteDataReader

- (NSString*) pathForKey:(id)key
{
    return [[NSBundle mainBundle] pathForResource:@"weeklyChart" ofType:@"json"];
}

@end

@interface MGMPreloadWeeklyChartRemoteDataSource : MGMWeeklyChartRemoteDataSource

@end

@implementation MGMPreloadWeeklyChartRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    return [[MGMPreloadWeeklyChartRemoteDataReader alloc] init];
}

@end

@implementation MGMPreloadWeeklyChartDaoOperation

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMPreloadWeeklyChartRemoteDataSource alloc] init];
}

- (NSUInteger) daysBetweenRemoteFetch
{
    return 0;
}

- (BOOL) needsRefresh:(MGMNextUrlAccess*)nextAccess
{
    return nextAccess == nil;
}

@end
