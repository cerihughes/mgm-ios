//
//  MGMRemoteDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

#import "MGMRemoteData.h"

@implementation MGMRemoteDataReader

- (NSData*) readRemoteData:(id)key error:(NSError**)error
{
    // OVERRIDE
    return nil;
}

- (void) markRemoteDataAsInvalid:(id)key
{
    // OVERRIDE
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

- (instancetype) init
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

- (oneway void) fetchRemoteData:(id)key completion:(REMOTE_DATA_FETCH_COMPLETION)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* readError = nil;
        NSData* data = [self.remoteDataReader readRemoteData:key error:&readError];
        MGMRemoteData* remoteData = [self.remoteDataConverter convertRemoteData:data key:key];

        if (remoteData.error)
        {
            // Mark this data as invalid so we don't try and read it again in this session.
            [self.remoteDataReader markRemoteDataAsInvalid:key];
        }
        else if (readError)
        {
            remoteData.error = readError;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(remoteData);
        });
    });
}

@end
