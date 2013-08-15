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

- (NSArray*) weeklyTimePeriods:(NSError**)error;
- (MGMTimePeriod*) mostRecentTimePeriod:(NSError**)error;
- (MGMWeeklyChart*) topWeeklyAlbumsForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error;

@end
