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

- (NSArray*) weeklyTimePeriods;
- (MGMWeeklyChart*) topWeeklyAlbums:(NSUInteger)count forTimePeriod:(MGMTimePeriod*)timePeriod;
- (MGMWeeklyChart*) topWeeklyAlbumsForMostRecentTimePeriod:(NSUInteger)count;

@end
