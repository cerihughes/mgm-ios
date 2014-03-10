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

@interface MGMDao : NSObject

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (void) setReachability:(BOOL)reachability;

- (MGMDaoData*) preloadEvents;
- (MGMDaoData*) preloadTimePeriods;
- (MGMDaoData*) preloadWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

- (MGMDaoData*) fetchAllEvents;
- (MGMDaoData*) fetchAllClassicAlbums;
- (MGMDaoData*) fetchAllNewlyReleasedAlbums;
- (MGMDaoData*) fetchAllEventAlbums;

- (MGMDaoData*) fetchAllTimePeriods;
- (MGMDaoData*) fetchWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

- (MGMDaoData*) fetchPlaylist:(NSString*)playlistId;

@end
