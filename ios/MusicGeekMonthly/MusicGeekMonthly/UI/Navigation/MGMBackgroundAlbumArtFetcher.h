//
//  MGMBackgroundAlbumArtFetcher.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbumImageSize.h"
#import "MGMBackgroundAlbumArtCollection.h"
#import "MGMImageHelper.h"

@class MGMBackgroundAlbumArtFetcher;

@protocol MGMBackgroundAlbumArtFetcherDelegate <NSObject>

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher renderImage:(UIImage*)image atIndex:(NSUInteger)index;
- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher errorOccured:(NSError*)error atIndex:(NSUInteger)index;

@end

@interface MGMBackgroundAlbumArtFetcher : NSObject

@property (weak) id<MGMBackgroundAlbumArtFetcherDelegate> delegate;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImageHelper:(MGMImageHelper *)imageHelper albumArtCollection:(MGMBackgroundAlbumArtCollection *)albumArtCollection;

- (void) renderImages:(NSUInteger)imageCount;

@end
