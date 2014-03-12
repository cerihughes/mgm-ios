//
//  MGMCore.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCore.h"

#import "MGMTimePeriod.h"

@implementation MGMCore

- (id) init
{
    if (self = [super init])
    {
        _coreDataAccess = [[MGMCoreDataAccess alloc] init];
        _dao = [[MGMDao alloc] initWithCoreDataAccess:_coreDataAccess];
        _settingsDao = [[MGMSettingsDao alloc] init];
        _albumRenderService = [[MGMAlbumRenderService alloc] initWithCoreDataAccess:_coreDataAccess];
        _serviceManager = [[MGMAlbumServiceManager alloc] initWithCoreDataAccess:_coreDataAccess];
    }
    return self;
}

- (void) setReachability:(BOOL)reachability
{
    self.dao.reachability = reachability;
    self.albumRenderService.reachability = reachability;
    self.serviceManager.reachability = reachability;
}

- (void) performBackgroundFetch:(BACKGROUND_FETCH_COMPLETION)completion
{
     [self.dao fetchAllEvents:^(MGMDaoData* eventData) {
         [self.dao fetchAllTimePeriods:^(MGMDaoData* timePeriodsData) {
             NSArray* timePeriods = timePeriodsData.data;
             if (timePeriods.count > 0)
             {
                 MGMTimePeriod* timePeriod = [self.coreDataAccess threadVersion:[timePeriods objectAtIndex:0]];
                 [self.dao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMDaoData* chartData) {
                     if (eventData.isNew || timePeriodsData.isNew || chartData.isNew)
                     {
                         completion(MGMCoreBackgroundFetchResultNewData);
                         return;
                     }
                     
                     if (eventData.error || timePeriodsData.error || chartData.error)
                     {
                         completion(MGMCoreBackgroundFetchResultFailed);
                         return;
                     }
                     completion(MGMCoreBackgroundFetchResultNoData);
                 }];
             }
             else
             {
                 completion(MGMCoreBackgroundFetchResultFailed);
             }
         }];
     }];
}

@end
