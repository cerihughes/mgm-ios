//
//  MGMBackgroundAlbumArtFetcher.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMBackgroundAlbumArtFetcher.h"

#import "MGMBackgroundAlbumArtCollection.h"
#import "MGMImageHelper.h"
#import "NSMutableArray+Shuffling.h"

@interface MGMBackgroundAlbumArtFetcher ()

@property (readonly) MGMBackgroundAlbumArtCollection* albumArtCollection;
@property (readonly) MGMImageHelper* imageHelper;
@property (readonly) NSOperationQueue* operationQueue;
@property BOOL initialRender;

@end

@implementation MGMBackgroundAlbumArtFetcher

#define INITIAL_SLEEP 0.2
#define SECOND_SLEEP 5.0
#define ERROR_SLEEP 3.0

- (id) initWithImageHelper:(MGMImageHelper*)imageHelper albumArtCollection:(MGMBackgroundAlbumArtCollection*)albumArtCollection
{
    if (self = [super init])
    {
        _albumArtCollection = albumArtCollection;
        _imageHelper = imageHelper;
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 2;
        _initialRender = YES;
    }
    return self;
}

- (void) renderImages:(NSUInteger)imageCount
{
    NSArray* shuffledIndicies = [self shuffledIndicies:imageCount];
    NSTimeInterval sleepTime = self.initialRender ? INITIAL_SLEEP : SECOND_SLEEP;
    for (NSUInteger i = 0; i < imageCount; i++)
    {
        NSNumber* index = [shuffledIndicies objectAtIndex:i];
        [self generateImageAtIndex:[index integerValue] sleepTime:sleepTime];
    }

    if (self.initialRender)
    {
        self.initialRender = NO;
        [self renderImages:imageCount];
    }
}

- (NSArray*) shuffledIndicies:(NSUInteger)size
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < size; i++)
    {
        [array addObject:[NSNumber numberWithInteger:i]];
    }
    [array shuffle];
    return [array copy];
}

- (void) generateImageAtIndex:(NSUInteger)index sleepTime:(NSTimeInterval)sleepTime
{
    if (self.albumArtCollection.albumArtUrlArrays.count == 0)
    {
        [self.delegate artFetcher:self renderImage:nil atIndex:index];
    }
    else
    {
        [self.operationQueue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:sleepTime];
            [self generateImageSyncAtIndex:index retry:YES];
        }];
    }
}

- (void) generateImageSyncAtIndex:(NSUInteger)index retry:(BOOL)retry
{
    NSArray* albumArtArrays = self.albumArtCollection.albumArtUrlArrays;
    int randomIndex = arc4random() % (albumArtArrays.count);
    NSArray* urls = [albumArtArrays objectAtIndex:randomIndex];
    if (urls.count > 0)
    {
        [self.imageHelper imageFromUrls:urls completion:^(UIImage* image, NSError* imageError) {
            if (image)
            {
                [self.delegate artFetcher:self renderImage:image atIndex:index];
            }
            else
            {
                if (retry)
                {
                    [self generateImageSyncAtIndex:index retry:NO];
                }
                else
                {
                    [self.delegate artFetcher:self errorOccured:imageError atIndex:index];
                }
            }
        }];
    }
    else
    {
        [self.delegate artFetcher:self renderImage:nil atIndex:index];
    }
}

@end
