//
//  MGMCore.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;

@class MGMAlbumRenderService;
@class MGMAlbumServiceManager;
@class MGMCoreDataAccess;
@class MGMDao;
@class MGMSettingsDao;

typedef NS_ENUM(NSUInteger, MGMCoreBackgroundFetchResult)
{
    MGMCoreBackgroundFetchResultNoData,
    MGMCoreBackgroundFetchResultNewData,
    MGMCoreBackgroundFetchResultFailed
};

typedef void (^BACKGROUND_FETCH_COMPLETION) (MGMCoreBackgroundFetchResult);

@interface MGMCore : NSObject

@property (readonly) MGMCoreDataAccess* coreDataAccess;
@property (readonly) MGMDao* dao;
@property (readonly) MGMSettingsDao* settingsDao;
@property (readonly) MGMAlbumRenderService* albumRenderService;
@property (readonly) MGMAlbumServiceManager* serviceManager;

- (void) setReachability:(BOOL)reachability;

- (void) performBackgroundFetch:(BACKGROUND_FETCH_COMPLETION)completion;

@end
