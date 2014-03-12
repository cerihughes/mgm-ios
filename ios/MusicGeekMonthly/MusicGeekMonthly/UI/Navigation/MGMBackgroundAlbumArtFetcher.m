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
        [self.delegate artFetcher:self renderImage:nil atIndex:index];
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

    [self.albumRenderService refreshAlbum:randomAlbum completion:^(NSError* refreshError) {
        if (refreshError == nil)
        {
            NSArray* urls = [randomAlbum bestImageUrlsWithPreferredSize:self.preferredSize];
            if (urls.count > 0)
            {
                [self.imageHelper imageFromUrls:urls completion:^(UIImage* image, NSError* imageError) {
                    [self.delegate artFetcher:self renderImage:image atIndex:index];
                }];
            }
            else
            {
                [self.delegate artFetcher:self renderImage:nil atIndex:index];
            }
        }
        else
        {
            [self.delegate artFetcher:self errorOccured:refreshError atIndex:index];
        }
    }];
}

@end
