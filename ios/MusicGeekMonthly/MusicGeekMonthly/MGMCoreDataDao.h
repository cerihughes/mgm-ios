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

- (MGMTimePeriod*) createNewTimePeriod:(NSError**)error;
- (MGMWeeklyChart*) createNewWeeklyChart:(NSError**)error;
- (MGMChartEntry*) createNewChartEntry:(NSError**)error;
- (MGMAlbum*) createNewAlbum:(NSError**)error;
- (MGMAlbumImageUri*) createNewAlbumImageUri:(NSError**)error;
- (MGMAlbumMetadata*) createNewAlbumMetadata:(NSError**)error;
- (MGMEvent*) createNewEvent:(NSError**)error;

- (MGMTimePeriod*) fetchTimePeriod:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error;
- (MGMWeeklyChart*) fetchWeeklyChart:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error;
- (MGMAlbum*) fetchAlbum:(NSString*)albumMbid error:(NSError**)error;
- (MGMAlbumImageUri*) fetchAlbumImageUriForAlbum:(MGMAlbum*)album size:(MGMAlbumImageSize)size error:(NSError**)error;
- (MGMAlbumMetadata*) fetchAlbumMetadataForAlbum:(MGMAlbum*)album serviceType:(MGMAlbumServiceType)serviceType error:(NSError**)error;
- (MGMEvent*) fetchEvent:(NSNumber*)eventNumber error:(NSError**)error;

- (void) persistChanges:(NSError**)error;

@end
