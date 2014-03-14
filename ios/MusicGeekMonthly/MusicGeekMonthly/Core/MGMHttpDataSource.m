//
//  MGMHttpDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDataSource.h"

#import "MGMErrorCodes.h"

@interface MGMHttpDataSource ()

/** Some urls will 404 or produce errors. We can build up a list of these and prevent further access, but not permanently as this can change (i.e. don't persist). */
@property (readonly) NSMutableSet* invalidUrls;

@end

@implementation MGMHttpDataSource

- (id) init
{
    if (self = [super init])
    {
        _invalidUrls = [NSMutableSet set];
    }
    return self;
}

- (void) addInvalidUrl:(NSString *)invalidUrl
{
    @synchronized (self.invalidUrls)
    {
        if ([self.invalidUrls containsObject:invalidUrl] == NO)
        {
            NSLog(@"Marking url as invalid: %@", invalidUrl);
            [self.invalidUrls addObject:invalidUrl];
        }
    }
}

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
    BOOL invalidUrl;
    @synchronized (self.invalidUrls)
    {
        invalidUrl = [self.invalidUrls containsObject:url];
    }
    if (invalidUrl == NO)
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
    else
    {
        if (error)
        {
            *error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_URL_MARKED_INVALID userInfo:nil];
        }
        return nil;
    }
}

@end
