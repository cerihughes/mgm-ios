//
//  MGMHttpDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDataSource.h"

@implementation MGMHttpDataSource

- (id) init
{
    if (self = [super init])
    {
        _hasReachability = YES;
    }
    return self;
}

- (NSData*) contentsOfUrl:(NSString*)url error:(NSError**)error
{
    return [self contentsOfUrl:url withHttpHeaders:nil error:error];
}

- (NSData*) contentsOfUrl:(NSString*)url withHttpHeaders:(NSDictionary*)headers error:(NSError**)error
{
    NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [request addValue:obj forHTTPHeaderField:key];
     }];

    NSHTTPURLResponse *urlResponse = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:error];
    NSLog(@"[%@] = [%ld]", url, (long)urlResponse.statusCode);
    return data;
}

@end
