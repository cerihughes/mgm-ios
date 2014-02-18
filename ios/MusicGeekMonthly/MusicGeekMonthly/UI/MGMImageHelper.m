//
//  MGMImageHelper.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImageHelper.h"

@interface MGMImageHelper ()

@property (readonly) NSLock* defaultImageLock;
@property NSUInteger defaultImageSuffix;

@end

@implementation MGMImageHelper

- (id) init
{
    if (self = [super init])
    {
        _defaultImageLock = [[NSLock alloc] init];
        _defaultImageSuffix = 1;
    }
    return self;
}

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
