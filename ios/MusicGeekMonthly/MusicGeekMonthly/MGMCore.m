//
//  MGMCore.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCore.h"

#define REACHABILITY_END_POINT @"music-geek-monthly.appspot.com"

@implementation MGMCore

- (id) init
{
    if (self = [super init])
    {
        _reachabilityManager = [[MGMReachabilityManager alloc] init];
        [_reachabilityManager registerForReachabilityTo:REACHABILITY_END_POINT];

        _coreDataAccess = [[MGMCoreDataAccess alloc] init];
        _dao = [[MGMDao alloc] initWithCoreDataAccess:_coreDataAccess];
        _settingsDao = [[MGMSettingsDao alloc] init];
        _albumRenderService = [[MGMAlbumRenderService alloc] initWithCoreDataAccess:_coreDataAccess];
        _serviceManager = [[MGMAlbumServiceManager alloc] initWithCoreDataAccess:_coreDataAccess];
    }
    return self;
}

- (MGMCoreBackgroundFetchResult) performBackgroundFetch
{
    return MGMCoreBackgroundFetchResultNoData;
}

@end
