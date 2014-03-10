//
//  MGMRemoteHttpDataReader.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteHttpDataReader.h"

#import "MGMErrorCodes.h"
#import "MGMHttpDataSource.h"

@interface MGMRemoteHttpDataReader ()

@property (readonly) MGMHttpDataSource* httpDataSource;

@end

@implementation MGMRemoteHttpDataReader

- (id) init
{
    if (self = [super init])
    {
        _httpDataSource = [[MGMHttpDataSource alloc] init];
    }
    return self;
}

- (NSData*) readRemoteData:(id)key error:(NSError**)error
{
    if (self.reachability)
    {
        NSString* url = [self urlForKey:key];
        if (url)
        {
            return [self.httpDataSource contentsOfUrl:url withHttpHeaders:[self httpHeaders] error:error];
        }
    }
    else
    {
        if (error)
        {
            *error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_NO_REACHABILITY userInfo:nil];
        }
    }
    return nil;
}

- (NSString*) urlForKey:(id)key
{
    // OVERRIDE
    return nil;
}

- (NSDictionary*) httpHeaders
{
    return nil;
}

@end
