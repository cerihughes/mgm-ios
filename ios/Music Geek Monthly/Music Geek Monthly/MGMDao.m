//
//  MGMDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"

@implementation MGMDao

- (NSData*) getContentsOfUrl:(NSString*)url
{
    return [self getContentsOfUrl:url withHttpHeaders:nil];
}

- (NSData*) getContentsOfUrl:(NSString*)url withHttpHeaders:(NSDictionary*)headers
{
    NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        [request addValue:obj forHTTPHeaderField:key];
    }];

    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
}

@end
