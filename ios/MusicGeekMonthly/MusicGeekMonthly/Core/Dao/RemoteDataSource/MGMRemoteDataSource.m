//
//  MGMRemoteDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource+Protected.h"

#import "MGMErrorCodes.h"

@implementation MGMRemoteDataSource

- (MGMRemoteData*) fetchRemoteData:(id)key
{
    if (self.reachability)
    {
        NSDictionary* json = nil;
        NSString* url = [self urlForKey:key];
        if (url)
        {
            NSError* urlFetchError = nil;
            NSData* remoteData = [self contentsOfUrl:url withHttpHeaders:[self httpHeaders] error:&urlFetchError];
            if (urlFetchError)
            {
                return [MGMRemoteData dataWithError:urlFetchError];
            }

            if (remoteData)
            {
                NSError* jsonError = nil;
                json = [NSJSONSerialization JSONObjectWithData:remoteData options:0 error:&jsonError];
                if (jsonError)
                {
                    return [MGMRemoteData dataWithError:jsonError];
                }
            }
        }

        return [self convertJsonData:json key:key];
    }
    else
    {
        NSError* reachabilityError = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_NO_REACHABILITY userInfo:nil];
        return [MGMRemoteData dataWithError:reachabilityError];
    }
}

@end

@implementation MGMRemoteDataSource (Protected)

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

- (NSString*) urlForKey:(id)key
{
    return nil;
}

- (NSDictionary*) httpHeaders
{
    return nil;
}

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
{
    return nil;
}

@end
