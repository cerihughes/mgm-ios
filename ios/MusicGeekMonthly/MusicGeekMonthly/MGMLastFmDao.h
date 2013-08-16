//
//  MGMLastFmDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumMetadataDao.h"
#import "MGMWeeklyChart.h"
#import "MGMTimePeriod.h"

@interface MGMLastFmDao : MGMAlbumMetadataDao

- (void) weeklyTimePeriods:(FETCH_MANY_COMPLETION)completion;
- (void) mostRecentTimePeriod:(FETCH_COMPLETION)completion;
- (void) topWeeklyAlbumsForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion;

@end
