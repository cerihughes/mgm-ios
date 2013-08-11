//
//  MGMCoreDataDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"
#import "MGMWeeklyChart.h"
#import "MGMEvent.h"
#import "MGMAlbum.h"
#import "MGMTimePeriod.h"

@interface MGMCoreDataDao : MGMDao

- (MGMWeeklyChart*) createNewWeeklyChart:(NSError**)error;
- (MGMEvent*) createNewEvent:(NSError**)error;
- (MGMAlbum*) createNewAlbum:(NSError**)error;
- (MGMTimePeriod*) createNewMGMTimePeriod:(NSError**)error;

@end
