//
//  MGMPreloadAllEventsGoogleSheetDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/03/2015.
//  Copyright (c) 2015 Ceri Hughes. All rights reserved.
//

#import "MGMPreloadAllEventsGoogleSheetDaoOperation.h"

#import "MGMRemoteFileDataReader.h"

@interface MGMPreloadAllEventsGoogleSheetRemoteDataSource : MGMAllEventsGoogleSheetRemoteDataSource <MGMRemoteFileDataReaderDataSource>

@end

@implementation MGMPreloadAllEventsGoogleSheetRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    MGMRemoteFileDataReader *reader = [[MGMRemoteFileDataReader alloc] init];
    reader.dataSource = self;
    return reader;
}

#pragma mark - MGMRemoteFileDataReaderDataSource

- (NSString*) pathForKey:(id)key
{
    return [[NSBundle mainBundle] pathForResource:@"googleSheet" ofType:@"json"];
}

@end

@implementation MGMPreloadAllEventsGoogleSheetDaoOperation

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMPreloadAllEventsGoogleSheetRemoteDataSource alloc] init];
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
