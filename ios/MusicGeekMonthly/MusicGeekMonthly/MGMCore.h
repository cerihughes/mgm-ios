//
//  MGMCore.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbumRenderService.h"
#import "MGMAlbumServiceManager.h"
#import "MGMDao.h"
#import "MGMReachabilityManager.h"
#import "MGMSettingsDao.h"

typedef NS_ENUM(NSUInteger, MGMCoreBackgroundFetchResult)
{
    MGMCoreBackgroundFetchResultNoData,
    MGMCoreBackgroundFetchResultNewData,
    MGMCoreBackgroundFetchResultFailed
};

@interface MGMCore : NSObject

@property (readonly) MGMReachabilityManager* reachabilityManager;
@property (readonly) MGMCoreDataAccess* coreDataAccess;
@property (readonly) MGMDao* dao;
@property (readonly) MGMSettingsDao* settingsDao;
@property (readonly) MGMAlbumRenderService* albumRenderService;
@property (readonly) MGMAlbumServiceManager* serviceManager;

- (MGMCoreBackgroundFetchResult) performBackgroundFetch;

@end
