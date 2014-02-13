//
//  MGMHttpDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDao.h"

@interface MGMHttpDao ()

@property (strong) MGMReachabilityManager* internalReachabilityManager;
@property (strong) NSDateFormatter* jsonDateFormatter;

@end

@implementation MGMHttpDao

- (id) initWithCoreDataDao:(MGMCoreDataDao*)coreDataDao reachabilityManager:(MGMReachabilityManager*)reachabilityManager
{
    if (self = [super initWithCoreDataDao:coreDataDao])
    {
        self.internalReachabilityManager = reachabilityManager;
        self.jsonDateFormatter = [[NSDateFormatter alloc] init];
        self.jsonDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    }
    return self;
}

- (MGMReachabilityManager*) reachabilityManager
{
    return self.internalReachabilityManager;
}

- (BOOL) needsUrlRefresh:(NSString*)identifier
{
    NSError* error = nil;
    MGMNextUrlAccess* nextAccess = [self.coreDataDao fetchNextUrlAccessWithIdentifier:identifier error:&error];
    if (error == nil && nextAccess)
    {
        NSDate* nextAccessDate = nextAccess.date;
        return ([[NSDate date] earlierDate:nextAccessDate] == nextAccessDate);
    }
    return YES;
}

- (void) setNextUrlRefresh:(NSString*)identifier inDays:(NSUInteger)days
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = days;

    NSDate* now = [NSDate date];
    NSDate* then = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:now options:0];

    [self.coreDataDao persistNextUrlAccess:identifier date:then completion:^(NSError* error)
    {
        // Swallow
    }];
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
    NSLog(@"[%@] = [%d]", url, urlResponse.statusCode);
    return data;
}

- (NSDate*) dateForJsonString:(NSString *)jsonString
{
    return [self.jsonDateFormatter dateFromString:jsonString];
}

@end
