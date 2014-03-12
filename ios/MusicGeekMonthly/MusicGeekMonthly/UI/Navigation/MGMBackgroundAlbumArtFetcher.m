//
//  MGMBackgroundAlbumArtFetcher.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMBackgroundAlbumArtFetcher.h"

#import "MGMChartEntry.h"
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

- (void) generateImageAtIndex:(NSUInteger)index sleepTime:(NSTimeInterval)sleepTime
{
    if (self.chartEntryMoids.count == 0)
    {
        [self fireDelegateForImage:nil index:index];
    }
    else
    {
        [self.operationQueue addOperationWithBlock:^
        {
            [self generateImageSyncAtIndex:index];
            [NSThread sleepForTimeInterval:sleepTime];
        }];
    }
}

- (void) generateImageSyncAtIndex:(NSUInteger)index
{
    int randomIndex = arc4random() % (self.chartEntryMoids.count);
    NSManagedObjectID* moid = [self.chartEntryMoids objectAtIndex:randomIndex];
    MGMChartEntry* randomEntry = [self.coreDataAccess threadVersion:moid];
    MGMAlbum* randomAlbum = randomEntry.album;
    NSError* error = nil;
    UIImage* image = [self fetchBestAlbumImage:randomAlbum error:&error];
    if (error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // ... fire the delegate in the main thread...
            [self.delegate artFetcher:self errorOccured:error atIndex:index];
        });
    }
    else
    {
        [self fireDelegateForImage:image index:index];
    }
}

- (void) fireDelegateForImage:(UIImage*)image index:(NSUInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // ... fire the delegate in the main thread...
        [self.delegate artFetcher:self renderImage:image atIndex:index];
    });
}

- (UIImage*) fetchBestAlbumImage:(MGMAlbum*)album error:(NSError**)error
{
    NSError* refreshError = nil;
    [self.albumRenderService refreshAlbumImages:album error:&refreshError];
    if (refreshError == nil)
    {
        NSArray* urls = [album bestImageUrlsWithPreferredSize:self.preferredSize];
        if (urls.count > 0)
        {
            return [self.imageHelper imageFromUrls:urls error:error];
        }
    }
    else
    {
        if (error)
        {
            *error = refreshError;
        }
    }
    return nil;
}

@end
