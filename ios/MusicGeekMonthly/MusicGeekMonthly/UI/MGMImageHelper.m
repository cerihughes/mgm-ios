//
//  MGMImageHelper.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImageHelper.h"

@implementation MGMImageHelper

+ (void) asyncImageFromUrls:(NSArray *)urls completion:(void (^)(UIImage*, NSError*))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        UIImage* image = [self imageFromUrls:urls error:&error];
        completion(image, error);
    });
}

+ (UIImage*) imageFromUrls:(NSArray *)urls error:(NSError**)error
{
    for (NSString* url in urls)
    {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        NSHTTPURLResponse* response = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
        if (response.statusCode == 200 && data.length > 0)
        {
            return [UIImage imageWithData:data];
        }
    }
    return nil;
}

@end
