//
//  MGMCore.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCore.h"

#import "MGMTimePeriod.h"

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
    MGMDaoData* eventData = [self.dao fetchAllEvents];
    MGMDaoData* timePeriodsData = [self.dao fetchAllTimePeriods];
    NSArray* timePeriods = timePeriodsData.data;
    if (timePeriods.count > 0)
    {
        MGMTimePeriod* timePeriod = [timePeriods objectAtIndex:0];
        MGMDaoData* chartData = [self.dao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate];
        if (eventData.isNew || timePeriodsData.isNew || chartData.isNew)
        {
            return MGMCoreBackgroundFetchResultNewData;
        }

        if (eventData.error || timePeriodsData.error || chartData.error)
        {
            return MGMCoreBackgroundFetchResultFailed;
        }
        return MGMCoreBackgroundFetchResultNoData;
    }
    else
    {
        return MGMCoreBackgroundFetchResultFailed;
    }
}

@end
