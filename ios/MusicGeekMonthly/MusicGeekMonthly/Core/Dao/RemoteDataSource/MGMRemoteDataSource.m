//
//  MGMRemoteDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

#import "MGMErrorCodes.h"

@implementation MGMRemoteDataSource

- (MGMRemoteData*) fetchRemoteData:(id)key
{
    if (self.reachability)
    {
        NSData* remoteData = nil;
        NSString* url = [self urlForKey:key];
        if (url)
        {
            NSError* urlFetchError = nil;
            remoteData = [self contentsOfUrl:url withHttpHeaders:[self httpHeaders] error:&urlFetchError];
            if (urlFetchError)
            {
                return [MGMRemoteData dataWithError:urlFetchError];
            }
        }

        return [self convertRemoteData:remoteData key:key];
    }
    else
    {
        NSError* reachabilityError = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_NO_REACHABILITY userInfo:nil];
        return [MGMRemoteData dataWithError:reachabilityError];
    }
}

@end

@implementation MGMRemoteDataSource (Protected)

- (NSString*) urlForKey:(id)key
{
    return nil;
}

- (NSDictionary*) httpHeaders
{
    return nil;
}

- (MGMRemoteData*) convertRemoteData:(NSData*)remoteData key:(id)key
{
    return nil;
}

@end
