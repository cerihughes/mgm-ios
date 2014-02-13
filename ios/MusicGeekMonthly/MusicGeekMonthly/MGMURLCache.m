//
//  MGMURLCache.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 27/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMURLCache.h"

@implementation MGMURLCache

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path
{
    if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path])
    {
    }
    return self;
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    return [super cachedResponseForRequest:request];
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    [super storeCachedResponse:cachedResponse forRequest:request];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request
{
    NSLog(@"%s called with parameter (%@).", __FUNCTION__, request);
    [super removeCachedResponseForRequest:request];
}

- (void)removeAllCachedResponses
{
    NSLog(@"%s called.", __FUNCTION__);
    [super removeAllCachedResponses];
}

- (NSUInteger)memoryCapacity
{
    NSUInteger result = [super memoryCapacity];
    return result;
}

- (NSUInteger)diskCapacity
{
    NSUInteger result = [super diskCapacity];
    return result;
}

- (void)setMemoryCapacity:(NSUInteger)memoryCapacity
{
    [super setMemoryCapacity:memoryCapacity];
}

- (void)setDiskCapacity:(NSUInteger)diskCapacity
{
    [super setDiskCapacity:diskCapacity];
}

- (NSUInteger)currentMemoryUsage
{
    NSUInteger result = [super currentMemoryUsage];
    NSLog(@"%s called. Returning (%d).", __FUNCTION__, result);
    return result;
}

- (NSUInteger)currentDiskUsage
{
    NSUInteger result = [super currentDiskUsage];
    NSLog(@"%s called. Returning (%d).", __FUNCTION__, result);
    return result;
}

@end
