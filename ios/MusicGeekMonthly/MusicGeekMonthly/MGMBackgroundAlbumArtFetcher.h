//
//  MGMBackgroundAlbumArtFetcher.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMDaoFactory.h"
#import "MGMWeeklyChart.h"

@class MGMBackgroundAlbumArtFetcher;

@protocol MGMBackgroundAlbumArtFetcherDelegate <NSObject>

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher renderImage:(UIImage*)image atIndex:(NSUInteger)index;
- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher errorOccured:(NSError*)error;

@end

@interface MGMBackgroundAlbumArtFetcher : NSObject

@property (weak) id<MGMBackgroundAlbumArtFetcherDelegate> delegate;
@property (strong) MGMDaoFactory* daoFactory;

- (id) initWithChartEntryMoids:(NSArray*)chartEntryMoids;
- (void) generateImageAtIndex:(NSUInteger)index;

@end
