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
#import "MGMPlaylistDaoOperation.h"
#import "MGMPreloadEventsDaoOperation.h"
#import "MGMPreloadTimePeriodsDaoOperation.h"
#import "MGMPreloadWeeklyChartDaoOperation.h"
#import "MGMWeeklyChartDaoOperation.h"

@interface MGMDao ()

@property (readonly) MGMPreloadEventsDaoOperation* preloadEventDaoOperation;
@property (readonly) MGMPreloadTimePeriodsDaoOperation* preloadTimePeriodDaoOperation;
@property (readonly) MGMPreloadWeeklyChartDaoOperation* preloadWeeklyChartDaoOperation;

@property (readonly) MGMAllEventsDaoOperation* eventDaoOperation;
@property (readonly) MGMAllTimePeriodsDaoOperation* timePeriodDaoOperation;
@property (readonly) MGMWeeklyChartDaoOperation* weeklyChartDaoOperation;
@property (readonly) MGMPlaylistDaoOperation* playlistDaoOperation;

@end

@implementation MGMDao

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _preloadEventDaoOperation = [[MGMPreloadEventsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _preloadEventDaoOperation.reachability = YES;
        _preloadTimePeriodDaoOperation = [[MGMPreloadTimePeriodsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _preloadTimePeriodDaoOperation.reachability = YES;
        _preloadWeeklyChartDaoOperation = [[MGMPreloadWeeklyChartDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _preloadWeeklyChartDaoOperation.reachability = YES;

        _eventDaoOperation = [[MGMAllEventsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _timePeriodDaoOperation = [[MGMAllTimePeriodsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _weeklyChartDaoOperation = [[MGMWeeklyChartDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _playlistDaoOperation = [[MGMPlaylistDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
    }
    return self;
}

- (void) setReachability:(BOOL)reachability
{
    self.eventDaoOperation.reachability = reachability;
    self.timePeriodDaoOperation.reachability = reachability;
    self.weeklyChartDaoOperation.reachability = reachability;
    self.playlistDaoOperation.reachability = reachability;
}

- (oneway void) preloadEvents:(DAO_FETCH_COMPLETION)completion
{
    [self.preloadEventDaoOperation fetchData:ALL_EVENTS_KEY completion:completion];
}

- (oneway void) preloadTimePeriods:(DAO_FETCH_COMPLETION)completion
{
    [self.preloadTimePeriodDaoOperation fetchData:nil completion:completion];
}

- (oneway void) preloadWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(DAO_FETCH_COMPLETION)completion
{
    MGMWeeklyChartData* data = [[MGMWeeklyChartData alloc] init];
    data.startDate = startDate;
    data.endDate = endDate;
    [self.preloadWeeklyChartDaoOperation fetchData:data completion:completion];
}

- (oneway void) fetchAllEvents:(DAO_FETCH_COMPLETION)completion
{
    [self.eventDaoOperation fetchData:ALL_EVENTS_KEY completion:completion];
}

- (oneway void) fetchAllClassicAlbums:(DAO_FETCH_COMPLETION)completion
{
    [self.eventDaoOperation fetchData:ALL_CLASSIC_ALBUMS_KEY completion:completion];
}

- (oneway void) fetchAllNewlyReleasedAlbums:(DAO_FETCH_COMPLETION)completion
{
    [self.eventDaoOperation fetchData:ALL_NEWLY_RELEASED_ALBUMS_KEY completion:completion];
}

- (oneway void) fetchAllEventAlbums:(DAO_FETCH_COMPLETION)completion
{
    [self.eventDaoOperation fetchData:ALL_EVENT_ALBUMS_KEY completion:completion];
}

- (oneway void) fetchAllTimePeriods:(DAO_FETCH_COMPLETION)completion
{
    [self.timePeriodDaoOperation fetchData:nil completion:completion];
}

- (oneway void) fetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(DAO_FETCH_COMPLETION)completion
{
    MGMWeeklyChartData* data = [[MGMWeeklyChartData alloc] init];
    data.startDate = startDate;
    data.endDate = endDate;
    [self.weeklyChartDaoOperation fetchData:data completion:completion];
}

- (oneway void) fetchPlaylist:(NSString*)playlistId completion:(DAO_FETCH_COMPLETION)completion
{
    [self.playlistDaoOperation fetchData:playlistId completion:completion];
}

@end
