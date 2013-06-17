//
//  MGMImageCache.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImageCache.h"

#define CACHE_SIZE 20

@interface MGMImageCache()

@property (strong) NSMutableDictionary* cache;
@property (strong) NSMutableDictionary* timestamps;

@end

@implementation MGMImageCache

- (id)init
{
    if (self = [super init])
    {
        self.cache = [NSMutableDictionary dictionaryWithCapacity:CACHE_SIZE];
        self.timestamps = [NSMutableDictionary dictionaryWithCapacity:CACHE_SIZE];
        self.cacheDurationInMinutes = 10;
    }
    return self;
}

- (void) asyncImageFromUrl:(NSString *)url completion:(void (^)(UIImage *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Fetch in a background thread...
        UIImage* image = [self imageFromUrl:url];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but respond in the main thread...
            completion(image);
        });
    });
}

- (UIImage*) imageFromUrl:(NSString *)url
{
    [self clearExpiredItems];

    NSDate* expiry = [NSDate dateWithTimeIntervalSinceNow:self.cacheDurationInMinutes * 60];
    UIImage* existing = [self.cache objectForKey:url];
    if (existing)
    {
        // Update the timestamp
        @synchronized(self)
        {
            NSLog(@"Extending caching of %@ until %@", url, expiry);
            [self.timestamps setObject:expiry forKey:url];
        }
        return existing;
    }
    else
    {
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        if (image)
        {
            // Put the image into the cache
            @synchronized(self)
            {
                NSLog(@"Caching %@ until %@", url, expiry);
                [self.timestamps setObject:expiry forKey:url];
                [self.cache setObject:image forKey:url];
            }
        }
        return image;
    }
}

- (void) clearExpiredItems
{
    NSMutableArray* keysToDelete = [NSMutableArray arrayWithCapacity:self.timestamps.count];
    @synchronized(self)
    {
        for (NSString* url in [self.timestamps keyEnumerator])
        {
            NSDate* expiry = [self.timestamps objectForKey:url];
            NSTimeInterval interval = [expiry timeIntervalSinceNow];
            if (interval < 0)
            {
                NSLog(@"%@ expired at %@", url, expiry);
                [keysToDelete addObject:url];
            }
        }
        [self.timestamps removeObjectsForKeys:keysToDelete];
        [self.cache removeObjectsForKeys:keysToDelete];
    }
}

@end
