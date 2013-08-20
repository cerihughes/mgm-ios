//
//  MGMDaoFetchOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDaoFetchOperation.h"

@interface MGMDaoFetchOperation ()

@property NSUInteger daysBetweenUrlFetch;

@end

@implementation MGMDaoFetchOperation

- (id) initWithCoreDataDao:(MGMCoreDataDao *)coreDataDao daysBetweenUrlFetch:(NSUInteger)daysBetweenUrlFetch
{
    if (self = [super initWithCoreDataDao:coreDataDao])
    {
        self.daysBetweenUrlFetch = daysBetweenUrlFetch;
    }
    return self;
}

- (void) executeWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    NSString* refreshIdentifier = [self refreshIdentifierForData:data];
    if ([self needsUrlRefresh:refreshIdentifier])
    {
        NSError* error = nil;
        NSString* url = [self urlForData:data];
        NSData* jsonData = [self contentsOfUrl:url withHttpHeaders:[self httpHeaders] error:&error];
        if (error == nil && jsonData)
        {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            if (error == nil && json)
            {
                [self convertJsonData:json forData:data completion:^(id urlData, NSError* convertError)
                {
                    if (convertError == nil && urlData)
                    {
                        [self coreDataPersistConvertedData:urlData withData:data completion:^(NSError* coreDataPersistError)
                        {
                            if (coreDataPersistError == nil)
                            {
                                [self coreDataFetchWithData:data completion:completion];
                            }
                            else
                            {
                                completion(nil, coreDataPersistError);
                            }
                        }];
                        [self setNextUrlRefresh:refreshIdentifier inDays:self.daysBetweenUrlFetch];
                    }
                    else
                    {
                        completion(nil, convertError);
                    }
                }];
            }
            else
            {
                completion(nil, error);
            }
        }
        else
        {
            completion(nil, error);
        }
    }
    else
    {
        [self coreDataFetchWithData:data completion:completion];
    }
}

#pragma mark -
#pragma mark Override the following

- (NSString*) refreshIdentifierForData:(id)data
{
    return nil;
}

- (NSString*) urlForData:(id)data
{
    return nil;
}

- (NSDictionary*) httpHeaders
{
    return nil;
}

- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion
{
    completion(nil, nil);
}

- (void) coreDataPersistConvertedData:(id)convertedUrlData withData:(id)data completion:(VOID_COMPLETION)completion
{
    completion(nil);
}

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    completion(nil, nil);
}

@end
