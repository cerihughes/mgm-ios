//
//  MGMBackgroundAlbumArtFetcher.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMBackgroundAlbumArtFetcher.h"

#import "MGMImageHelper.h"

@interface MGMBackgroundAlbumArtFetcher ()

@property (readonly) NSArray* chartEntryMoids;
@property (readonly) MGMImageHelper* imageHelper;
@property (readonly) NSOperationQueue* operationQueue;

@end

@implementation MGMBackgroundAlbumArtFetcher

- (id) initWithImageHelper:(MGMImageHelper*)imageHelper chartEntryMoids:(NSArray*)chartEntryMoids
{
    if (self = [super init])
    {
        _chartEntryMoids = chartEntryMoids;
        _imageHelper = imageHelper;
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (void) generateImageAtIndex:(NSUInteger)index
{
    if (self.chartEntryMoids.count == 0)
    {
        [self fireDelegateForImage:nil index:index];
    }
    else
    {
        [self.operationQueue addOperationWithBlock:^
        {
            [self generateImageSyncAtIndex:index attempt:0];
        }];
    }
}

- (void) generateImageSyncAtIndex:(NSUInteger)index attempt:(NSUInteger)attempt
{
    if (attempt == 5)
    {
        [self fireDelegateForImage:nil index:index];
    }
    else
    {
        int randomIndex = arc4random() % (self.chartEntryMoids.count);
        NSManagedObjectID* moid = [self.chartEntryMoids objectAtIndex:randomIndex];
        MGMChartEntry* randomEntry = [self.coreDataAccess threadVersion:moid];
        MGMAlbum* randomAlbum = randomEntry.album;
        [self fetchBestAlbumImage:randomAlbum completion:^(UIImage* image, NSError* error)
        {
            if (error)
            {
                [self.delegate artFetcher:self errorOccured:error];
            }
            else
            {
                if (image == nil)
                {
                    [self generateImageSyncAtIndex:index attempt:attempt + 1];
                }
                else
                {
                    [self fireDelegateForImage:image index:index];
                }
            }
        }];
    }
}

- (void) fireDelegateForImage:(UIImage*)image index:(NSUInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        // ... fire the delegate in the main thread...
        [self.delegate artFetcher:self renderImage:image atIndex:index];
    });
}

- (void) fetchBestAlbumImage:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion
{
    NSError* refreshError = nil;
    [self.albumRenderService refreshAlbumImages:album error:&refreshError];
    if (refreshError == nil)
    {
        NSArray* urls = [album bestImageUrlsWithPreferredSize:self.preferredSize];
        NSError* imageError = nil;
        UIImage* image = nil;
        if (urls.count > 0)
        {
            image = [self.imageHelper imageFromUrls:urls error:&imageError];
        }
        completion(image, imageError);
    }
    else
    {
        completion(nil, refreshError);
    }
}

@end
