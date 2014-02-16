//
//  MGMImageHelper.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImageHelper.h"

@implementation MGMImageHelper

- (void) asyncImageFromUrls:(NSArray *)urls completion:(void (^)(UIImage*, NSError*))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        UIImage* image = [self imageFromUrls:urls error:&error];
        completion(image, error);
    });
}

- (UIImage*) imageFromUrls:(NSArray *)urls error:(NSError**)error
{
    for (NSString* url in urls)
    {
        NSInteger response = 0;
        NSData* data = [self contentsOfUrl:url responseCode:&response error:error];
        if (response == 200 && data.length > 0)
        {
            return [UIImage imageWithData:data];
        }
    }
    return nil;
}

@end
