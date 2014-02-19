//
//  MGMDao.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"

#import "MGMAllEventsDaoOperation.h"
#import "MGMAllTimePeriodsDaoOperation.h"
#import "MGMCoreDataAccess.h"
#import "MGMWeeklyChartDaoOperation.h"

@interface MGMDao ()

@property (readonly) MGMAllEventsDaoOperation* fetchEventDataOperation;
@property (readonly) MGMAllTimePeriodsDaoOperation* fetchAllTimePeriodsOperation;
@property (readonly) MGMWeeklyChartDaoOperation* fetchWeeklyChartOperation;

@end

@implementation MGMDao

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _fetchEventDataOperation = [[MGMAllEventsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _fetchAllTimePeriodsOperation = [[MGMAllTimePeriodsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _fetchWeeklyChartOperation = [[MGMWeeklyChartDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
    }
    return self;
}

- (BOOL) reachability
{
    return self.fetchEventDataOperation.reachability;
}

- (void) setReachability:(BOOL)reachability
{
    self.fetchEventDataOperation.reachability = reachability;
    self.fetchAllTimePeriodsOperation.reachability = reachability;
    self.fetchWeeklyChartOperation.reachability = reachability;
}

- (MGMDaoData*) fetchAllEvents
{
    return [self.fetchEventDataOperation fetchData:ALL_EVENTS_KEY];
}

- (MGMDaoData*) fetchAllClassicAlbums
{
    return [self.fetchEventDataOperation fetchData:ALL_CLASSIC_ALBUMS_KEY];
}

- (MGMDaoData*) fetchAllNewlyReleasedAlbums
{
    return [self.fetchEventDataOperation fetchData:ALL_NEWLY_RELEASED_ALBUMS_KEY];
}

- (MGMDaoData*) fetchAllEventAlbums
{
    return [self.fetchEventDataOperation fetchData:ALL_EVENT_ALBUMS_KEY];
}

- (MGMDaoData*) fetchAllTimePeriods
{
    return [self.fetchAllTimePeriodsOperation fetchData:nil];
}

- (MGMDaoData*) fetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    MGMFetchWeeklyChartData* data = [[MGMFetchWeeklyChartData alloc] init];
    data.startDate = startDate;
    data.endDate = endDate;
    return [self.fetchWeeklyChartOperation fetchData:data];
}

@end
