//
//  MGMCoreDataDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"
#import "MGMTimePeriod.h"
#import "MGMTimePeriodDto.h"
#import "MGMWeeklyChart.h"
#import "MGMWeeklyChartDto.h"
#import "MGMAlbum.h"
#import "MGMAlbumDto.h"
#import "MGMEvent.h"
#import "MGMEventDto.h"

typedef void (^VOID_COMPLETION)(NSError*);
typedef void (^CREATION_COMPLETION)(id, NSError*);
typedef void (^FETCH_MANY_COMPLETION)(NSArray*, NSError*);
typedef CREATION_COMPLETION FETCH_COMPLETION;

@interface MGMCoreDataDao : MGMDao

- (id) init;
- (id) initWithStoreName:(NSString*)storeName;

- (void) persistTimePeriods:(NSArray*)timePeriodDtos completion:(VOID_COMPLETION)completion;
- (void) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto completion:(VOID_COMPLETION)completion;
- (void) persistEvents:(NSArray*)eventDtos completion:(VOID_COMPLETION)completion;
- (void) addImageUris:(NSArray*)uriDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType completion:(VOID_COMPLETION)completion;
- (void) addMetadata:(NSArray*)metadataDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType completion:(VOID_COMPLETION)completion;

- (void) fetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion;
- (void) fetchWeeklyChartWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion;
- (void) fetchChartEntryWithWeeklyChart:(MGMWeeklyChart*)weeklyChart rank:(NSNumber*)rank completion:(FETCH_COMPLETION)completion;
- (void) fetchAlbumWithMbid:(NSString*)mbid completion:(FETCH_COMPLETION)completion;
- (void) fetchAllEvents:(FETCH_MANY_COMPLETION)completion;
- (void) fetchEventWithEventNumber:(NSNumber*)eventNumber completion:(FETCH_COMPLETION)completion;

@end

