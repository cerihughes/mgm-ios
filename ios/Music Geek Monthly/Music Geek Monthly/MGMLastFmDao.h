//
//  MGMLastFmDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"
#import "MGMTimePeriod.h"
#import "MGMGroupAlbum.h"

@interface MGMLastFmDao : MGMDao

- (NSArray*) weeklyTimePeriods;
- (NSArray*) topWeeklyAlbums:(NSUInteger)count forTimePeriod:(MGMTimePeriod*)timePeriod;
- (NSArray*) topWeeklyAlbumsForMostRecentTimePeriod:(NSUInteger)count;
- (void) updateAlbumInfo:(MGMAlbum*)album;

@end
