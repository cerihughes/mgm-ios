//
//  MGMDao.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"

#import "MGMAllClassicAlbumsDaoOperation.h"
#import "MGMAllEventAlbumsDaoOperation.h"
#import "MGMAllEventsDaoOperation.h"
#import "MGMAllNewlyReleasedAlbumsDaoOperation.h"
#import "MGMAllTimePeriodsDaoOperation.h"
#import "MGMCoreDataAccess.h"
#import "MGMWeeklyChartDaoOperation.h"

@interface MGMDao ()

@property (readonly) MGMAllEventsDaoOperation* fetchAllEventsOperation;
@property (readonly) MGMAllClassicAlbumsDaoOperation* fetchAllClassicAlbumsOperation;
@property (readonly) MGMAllNewlyReleasedAlbumsDaoOperation* fetchAllNewlyReleasedAlbumsOperation;
@property (readonly) MGMAllEventAlbumsDaoOperation* fetchAllEventAlbumsOperation;
@property (readonly) MGMAllTimePeriodsDaoOperation* fetchAllTimePeriodsOperation;
@property (readonly) MGMWeeklyChartDaoOperation* fetchWeeklyChartOperation;

@end

@implementation MGMDao

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _fetchAllEventsOperation = [[MGMAllEventsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _fetchAllClassicAlbumsOperation = [[MGMAllClassicAlbumsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _fetchAllNewlyReleasedAlbumsOperation = [[MGMAllNewlyReleasedAlbumsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _fetchAllEventAlbumsOperation = [[MGMAllEventAlbumsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _fetchAllTimePeriodsOperation = [[MGMAllTimePeriodsDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
        _fetchWeeklyChartOperation = [[MGMWeeklyChartDaoOperation alloc] initWithCoreDataAccess:coreDataAccess];
    }
    return self;
}

- (MGMDaoData*) fetchAllEvents
{
    return [self.fetchAllEventsOperation fetchData:nil];
}

- (MGMDaoData*) fetchAllClassicAlbums
{
    return [self.fetchAllClassicAlbumsOperation fetchData:nil];
}

- (MGMDaoData*) fetchAllNewlyReleasedAlbums
{
    return [self.fetchAllNewlyReleasedAlbumsOperation fetchData:nil];
}

- (MGMDaoData*) fetchAllEventAlbums
{
    return [self.fetchAllEventAlbumsOperation fetchData:nil];
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
