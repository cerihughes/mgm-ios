//
//  MGMRemoteJsonDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteJsonDataSource.h"

@implementation MGMRemoteJsonDataSource

- (MGMRemoteData*) convertRemoteData:(NSData *)remoteData key:(id)key
{
    NSDictionary* json = nil;
    if (remoteData)
    {
        NSError* jsonError = nil;
        json = [NSJSONSerialization JSONObjectWithData:remoteData options:0 error:&jsonError];
        if (jsonError)
        {
            return [MGMRemoteData dataWithError:jsonError];
        }
    }
    return [self convertJsonData:json key:key];
}

@end

@implementation MGMRemoteJsonDataSource (Protected)

static NSDateFormatter* _jsonDateFormatter;

+ (void) initialize
{
    _jsonDateFormatter = [[NSDateFormatter alloc] init];
    _jsonDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
}

- (NSDate*) dateForJsonString:(NSString *)jsonString
{
    return [_jsonDateFormatter dateFromString:jsonString];
}

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
{
    return nil;
}

@end