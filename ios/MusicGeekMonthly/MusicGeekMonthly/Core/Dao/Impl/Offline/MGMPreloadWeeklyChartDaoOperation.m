//
//  MGMPreloadWeeklyChartDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPreloadWeeklyChartDaoOperation.h"

#import "MGMRemoteFileDataReader.h"

@interface MGMPreloadWeeklyChartRemoteDataSource : MGMWeeklyChartRemoteDataSource <MGMRemoteFileDataReaderDataSource>

@end

@implementation MGMPreloadWeeklyChartRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    MGMRemoteFileDataReader *reader = [[MGMRemoteFileDataReader alloc] init];
    reader.dataSource = self;
    return reader;
}

#pragma mark - MGMRemoteFileDataReaderDataSource

- (NSString*) pathForKey:(id)key
{
    return [[NSBundle mainBundle] pathForResource:@"weeklyChart" ofType:@"json"];
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
