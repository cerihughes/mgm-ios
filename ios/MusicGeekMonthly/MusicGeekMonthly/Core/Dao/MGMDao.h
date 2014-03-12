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

typedef void (^DAO_FETCH_COMPLETION) (MGMDaoData*);

@interface MGMDao : NSObject

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (void) setReachability:(BOOL)reachability;

- (void) preloadEvents:(DAO_FETCH_COMPLETION)completion;
- (void) preloadTimePeriods:(DAO_FETCH_COMPLETION)completion;
- (void) preloadWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(DAO_FETCH_COMPLETION)completion;

- (void) fetchAllEvents:(DAO_FETCH_COMPLETION)completion;
- (void) fetchAllClassicAlbums:(DAO_FETCH_COMPLETION)completion;
- (void) fetchAllNewlyReleasedAlbums:(DAO_FETCH_COMPLETION)completion;
- (void) fetchAllEventAlbums:(DAO_FETCH_COMPLETION)completion;

- (void) fetchAllTimePeriods:(DAO_FETCH_COMPLETION)completion;
- (void) fetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(DAO_FETCH_COMPLETION)completion;

- (void) fetchPlaylist:(NSString*)playlistId completion:(DAO_FETCH_COMPLETION)completion;

@end
