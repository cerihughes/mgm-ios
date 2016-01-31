//
//  MGMPreloadTimePeriodsDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPreloadTimePeriodsDaoOperation.h"

#import "MGMRemoteFileDataReader.h"

@interface MGMPreloadTimePeriodsRemoteDataSource : MGMAllTimePeriodsRemoteDataSource <MGMRemoteFileDataReaderDataSource>

@end

@implementation MGMPreloadTimePeriodsRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    MGMRemoteFileDataReader *reader = [[MGMRemoteFileDataReader alloc] init];
    reader.dataSource = self;
    return reader;
}

#pragma mark - MGMRemoteFileDataReaderDataSource

- (NSString*) pathForKey:(id)key
{
    return [[NSBundle mainBundle] pathForResource:@"timePeriods" ofType:@"json"];
}

@end

@implementation MGMPreloadTimePeriodsDaoOperation

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMPreloadTimePeriodsRemoteDataSource alloc] init];
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

