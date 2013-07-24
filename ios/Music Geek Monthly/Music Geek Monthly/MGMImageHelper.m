//
//  MGMImageHelper.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImageHelper.h"

@implementation MGMImageHelper

+ (void) asyncImageFromUrl:(NSString *)url completion:(void (^)(UIImage *))completion
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
    {
        UIImage* image = [UIImage imageWithData:data];
        // Respond in the main thread...
        dispatch_async(dispatch_get_main_queue(), ^
        {
            completion(image);
        });
    }];
}

+ (UIImage*) imageFromUrl:(NSString *)url
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [UIImage imageWithData:data];
}

@end
