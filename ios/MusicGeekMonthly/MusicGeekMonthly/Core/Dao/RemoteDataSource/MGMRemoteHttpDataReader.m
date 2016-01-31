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

- (id)init
{
    if (self = [super init])
    {
        _httpDataSource = [[MGMHttpDataSource alloc] init];
    }
    return self;
}

- (NSData *)readRemoteData:(id)key error:(NSError**)error
{
    if (self.reachability) {
        NSString *url = [self.dataSource urlForKey:key];
        if (url) {
            NSDictionary *httpHeaders = nil;
            if ([self.dataSource respondsToSelector:@selector(httpHeaders)]) {
                httpHeaders = [self.dataSource httpHeaders];
            }
            return [self.httpDataSource contentsOfUrl:url withHttpHeaders:httpHeaders error:error];
        }
    } else {
        if (error) {
            *error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_NO_REACHABILITY userInfo:nil];
        }
    }
    return nil;
}

- (void)markRemoteDataAsInvalid:(id)key
{
    NSString *url = [self.dataSource urlForKey:key];
    [self.httpDataSource addInvalidUrl:url];
}

@end
