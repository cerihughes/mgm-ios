//
//  MGMHttpDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDataSource.h"

@implementation MGMHttpDataSource

- (NSData*) contentsOfUrl:(NSString*)url error:(NSError**)error
{
    return [self contentsOfUrl:url withHttpHeaders:nil responseCode:nil error:error];
}

- (NSData*) contentsOfUrl:(NSString*)url responseCode:(out NSInteger*)responseCode error:(NSError**)error
{
    return [self contentsOfUrl:url withHttpHeaders:nil responseCode:responseCode error:error];
}

- (NSData*) contentsOfUrl:(NSString*)url withHttpHeaders:(NSDictionary*)headers error:(NSError**)error
{
    return [self contentsOfUrl:url withHttpHeaders:headers responseCode:nil error:error];
}

- (NSData*) contentsOfUrl:(NSString*)url withHttpHeaders:(NSDictionary*)headers responseCode:(out NSInteger*)responseCode error:(NSError**)error
{
    NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];

    NSHTTPURLResponse *urlResponse = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:error];
    NSInteger urlResponseCode = urlResponse.statusCode;
    NSLog(@"[%@] = [%ld]", url, (long)urlResponseCode);

    if (responseCode)
    {
        *responseCode = urlResponseCode;
    }
    return data;
}

@end
