//
//  MGMImageHelper.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImageHelper.h"

@interface MGMImageHelper ()

@property (readonly) NSOperationQueue* operationQueue;
@property (readonly) NSLock* defaultImageLock;
@property NSUInteger defaultImageSuffix;

@end

@implementation MGMImageHelper

- (id) init
{
    if (self = [super init])
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5;
        _defaultImageLock = [[NSLock alloc] init];
        _defaultImageSuffix = 1;
    }
    return self;
}

- (void) imageFromUrls:(NSArray *)urls completion:(IMAGE_HELPER_COMPLETION)completion
{
    [self.operationQueue addOperationWithBlock:^{
        NSError* error = nil;
        UIImage* image = [self imageFromUrls:urls error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image, error);
        });
    }];
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
        else
        {
            [self addInvalidUrl:url];
        }
    }
    return nil;
}

- (UIImage*) nextDefaultImage
{
    [self.defaultImageLock lock];
    @try
    {
        NSString* imageName = [NSString stringWithFormat:@"album%lu.png", (unsigned long)self.defaultImageSuffix++];
        if (self.defaultImageSuffix == 4)
        {
            self.defaultImageSuffix = 1;
        }
        return [UIImage imageNamed:imageName];
    }
    @finally
    {
        [self.defaultImageLock unlock];
    }
}

@end
