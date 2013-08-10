//
//  MGMLastFmDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumMetadataDao.h"
#import "MGMTimePeriod.h"

@interface MGMLastFmDao : MGMAlbumMetadataDao

- (NSArray*) weeklyTimePeriods;
- (NSArray*) topWeeklyAlbums:(NSUInteger)count forTimePeriod:(MGMTimePeriod*)timePeriod;
- (NSArray*) topWeeklyAlbumsForMostRecentTimePeriod:(NSUInteger)count;

@end
