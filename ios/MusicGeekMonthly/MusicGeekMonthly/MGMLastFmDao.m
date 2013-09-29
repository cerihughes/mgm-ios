//
//  MGMLastFmDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMLastFmDao.h"

#import "MGMFetchAlbumImageUrlsOperation.h"
#import "MGMFetchAllTimePeriodsOperation.h"
#import "MGMFetchWeeklyChartOperation.h"
#import "MGMLastFmConstants.h"

@interface MGMLastFmDao ()

@property (strong) MGMFetchAlbumImageUrlsOperation* fetchAlbumImageUrlsOperation;
@property (strong) MGMFetchAllTimePeriodsOperation* fetchAllTimePeriodsOperation;
@property (strong) MGMFetchWeeklyChartOperation* fetchWeeklyChartOperation;

@end

@implementation MGMLastFmDao

- (id) initWithCoreDataDao:(MGMCoreDataDao*)coreDataDao reachabilityManager:(MGMReachabilityManager*)reachabilityManager
{
    if (self = [super initWithCoreDataDao:coreDataDao reachabilityManager:reachabilityManager])
    {
        self.fetchAlbumImageUrlsOperation = [[MGMFetchAlbumImageUrlsOperation alloc] initWithCoreDataDao:coreDataDao reachabilityManager:reachabilityManager daysBetweenUrlFetch:0];
        self.fetchAllTimePeriodsOperation = [[MGMFetchAllTimePeriodsOperation alloc] initWithCoreDataDao:coreDataDao reachabilityManager:reachabilityManager daysBetweenUrlFetch:1];
        self.fetchWeeklyChartOperation = [[MGMFetchWeeklyChartOperation alloc] initWithCoreDataDao:coreDataDao reachabilityManager:reachabilityManager daysBetweenUrlFetch:21];
    }
    return self;
}

- (void) fetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    [self.fetchAllTimePeriodsOperation executeWithData:nil completion:completion];
}

- (void) fetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion
{
    MGMFetchWeeklyChartOperationData* data = [[MGMFetchWeeklyChartOperationData alloc] init];
    data.startDate = startDate;
    data.endDate = endDate;
    [self.fetchWeeklyChartOperation executeWithData:data completion:completion];
}

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion
{
    [self.fetchAlbumImageUrlsOperation executeWithData:album completion:completion];
}

@end
