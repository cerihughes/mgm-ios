//
//  MGMPreloadEventsDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPreloadEventsDaoOperation.h"

#import "MGMRemoteFileDataReader.h"

@interface MGMPreloadEventsRemoteDataReader : MGMRemoteFileDataReader

@end

@implementation MGMPreloadEventsRemoteDataReader

- (NSString*) pathForKey:(id)key
{
    return [[NSBundle mainBundle] pathForResource:@"events" ofType:@"json"];
}

@end

@interface MGMPreloadEventsRemoteDataSource : MGMAllEventsRemoteDataSource

@end

@implementation MGMPreloadEventsRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    return [[MGMPreloadEventsRemoteDataReader alloc] init];
}

@end

@implementation MGMPreloadEventsDaoOperation

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMPreloadEventsRemoteDataSource alloc] init];
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

