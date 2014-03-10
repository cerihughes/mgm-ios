//
//  MGMRemoteDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@implementation MGMRemoteDataReader

- (NSData*) readRemoteData:(id)key error:(NSError**)error
{
    // OVERRIDE
    return nil;
}

@end

@implementation MGMRemoteDataConverter

- (MGMRemoteData*) convertRemoteData:(NSData*)remoteData key:(id)key
{
    // OVERRIDE
    return nil;
}

@end

@interface MGMRemoteDataSource ()

@property (readonly) MGMRemoteDataReader* remoteDataReader;
@property (readonly) MGMRemoteDataConverter* remoteDataConverter;

@end

@implementation MGMRemoteDataSource

- (id) init
{
    if (self = [super init])
    {
        _remoteDataReader = [self createRemoteDataReader];
        _remoteDataConverter = [self createRemoteDataConverter];
    }
    return self;
}

- (MGMRemoteDataReader*) createRemoteDataReader
{
    // OVERRIDE
    return nil;
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    // OVERRIDE
    return nil;
}

- (void) setReachability:(BOOL)reachability
{
    self.remoteDataReader.reachability = reachability;
}

- (MGMRemoteData*) fetchRemoteData:(id)key
{
    NSError* error = nil;
    NSData* remoteData = [self.remoteDataReader readRemoteData:key error:&error];
    if (error == nil)
    {
        return [self.remoteDataConverter convertRemoteData:remoteData key:key];
    }
    else
    {
        return [MGMRemoteData dataWithError:error];
    }
}

@end
