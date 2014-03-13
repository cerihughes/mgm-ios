//
//  MGMDao.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMCoreDataAccess.h"
#import "MGMDaoData.h"
#import "MGMDaoOperation.h"

@interface MGMDao : NSObject

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (void) setReachability:(BOOL)reachability;

- (oneway void) preloadEvents:(DAO_FETCH_COMPLETION)completion;
- (oneway void) preloadTimePeriods:(DAO_FETCH_COMPLETION)completion;
- (oneway void) preloadWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(DAO_FETCH_COMPLETION)completion;

- (oneway void) fetchAllEvents:(DAO_FETCH_COMPLETION)completion;
- (oneway void) fetchAllClassicAlbums:(DAO_FETCH_COMPLETION)completion;
- (oneway void) fetchAllNewlyReleasedAlbums:(DAO_FETCH_COMPLETION)completion;
- (oneway void) fetchAllEventAlbums:(DAO_FETCH_COMPLETION)completion;

- (oneway void) fetchAllTimePeriods:(DAO_FETCH_COMPLETION)completion;
- (oneway void) fetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(DAO_FETCH_COMPLETION)completion;

- (oneway void) fetchPlaylist:(NSString*)playlistId completion:(DAO_FETCH_COMPLETION)completion;

@end
