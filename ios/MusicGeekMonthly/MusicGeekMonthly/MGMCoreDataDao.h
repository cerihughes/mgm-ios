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

typedef void (^VOID_COMPLETION)(NSError*);
typedef void (^CREATION_COMPLETION)(id, NSError*);
typedef void (^FETCH_MANY_COMPLETION)(NSArray*, NSError*);
typedef CREATION_COMPLETION FETCH_COMPLETION;

@interface MGMCoreDataDao : MGMDao

- (id) init;
- (id) initWithStoreName:(NSString*)storeName;

- (void) createNewTimePeriodForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(CREATION_COMPLETION)completion;
- (void) createNewWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(CREATION_COMPLETION)completion;
- (void) createNewChartEntryForRank:(NSNumber*)rank listeners:(NSNumber*)listeners completion:(CREATION_COMPLETION)completion;
- (void) createNewAlbumForMbid:(NSString*)mbid artistName:(NSString*)artistName albumName:(NSString*)albumName score:(NSNumber*)score completion:(CREATION_COMPLETION)completion;
- (void) createNewEventForEventNumber:(NSNumber*)eventNumber eventDate:(NSDate*)eventDate playlistId:(NSString*)playlistId completion:(CREATION_COMPLETION)completion;

- (void) fetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion;
- (void) fetchWeeklyChart:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion;
- (void) fetchAlbum:(NSString*)albumMbid completion:(FETCH_COMPLETION)completion;
- (void) fetchEvent:(NSNumber*)eventNumber completion:(FETCH_COMPLETION)completion;

- (void) addTimePeriods:(NSDictionary*)periods completion:(VOID_COMPLETION)completion;
- (void) addImageUris:(NSDictionary*)uris toAlbum:(MGMAlbum*)album completion:(VOID_COMPLETION)completion;
- (void) addMetadata:(NSDictionary*)metadata toAlbum:(MGMAlbum*)album completion:(VOID_COMPLETION)completion;

- (void) persistChanges:(VOID_COMPLETION)completion;

@end

