//
//  MGMCoreDataAccess.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbumMetadataDto.h"
#import "MGMEvent.h"
#import "MGMLocalDataSourceThreadManager.h"
#import "MGMNextUrlAccess.h"
#import "MGMPlaylistDto.h"
#import "MGMWeeklyChartDto.h"

#define MGM_NO_ERROR(_error) (((_error) == nil) || (*(_error) == nil))
#define MGM_ERROR(_error) (((_error) != nil) && (*(_error) != nil))

typedef void (^CORE_DATA_PERSIST_COMPLETION) (NSError*);
typedef void (^CORE_DATA_FETCH_COMPLETION) (NSManagedObjectID*, NSError*);
typedef void (^CORE_DATA_FETCH_MANY_COMPLETION) (NSArray*, NSError*);

@interface MGMCoreDataAccess : NSObject

#pragma mark -
#pragma mark MGMNextUrlAccess

- (oneway void) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date completion:(CORE_DATA_PERSIST_COMPLETION)completion;
- (oneway void) fetchNextUrlAccessWithIdentifier:(NSString*)identifier completion:(CORE_DATA_FETCH_COMPLETION)completion;

#pragma mark -
#pragma mark MGMTimePeriod

- (oneway void) persistTimePeriods:(NSArray*)timePeriodDtos completion:(CORE_DATA_PERSIST_COMPLETION)completion;
- (oneway void) fetchAllTimePeriods:(CORE_DATA_FETCH_MANY_COMPLETION)completion;

#pragma mark -
#pragma mark MGMWeeklyChart

- (oneway void) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto completion:(CORE_DATA_PERSIST_COMPLETION)completion;
- (oneway void) fetchWeeklyChartWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(CORE_DATA_FETCH_COMPLETION)completion;

#pragma mark -
#pragma mark MGMAlbum

- (oneway void) fetchAlbumWithMbid:(NSString*)mbid completion:(CORE_DATA_FETCH_COMPLETION)completion;

#pragma mark -
#pragma mark MGMAlbumImageUri

- (oneway void) addImageUris:(NSArray*)uriDtos toAlbum:(NSManagedObjectID*)albumMoid completion:(CORE_DATA_PERSIST_COMPLETION)completion;

#pragma mark -
#pragma mark MGMAlbumMetadata

- (oneway void) addMetadata:(MGMAlbumMetadataDto*)metadataDto toAlbum:(NSManagedObjectID*)albumMoid completion:(CORE_DATA_PERSIST_COMPLETION)completion;

#pragma mark -
#pragma mark MGMEvent

- (oneway void) persistEvents:(NSArray*)eventDtos completion:(CORE_DATA_PERSIST_COMPLETION)completion;
- (oneway void) fetchAllEvents:(CORE_DATA_FETCH_MANY_COMPLETION)completion;
- (oneway void) fetchEventWithEventNumber:(NSNumber*)eventNumber completion:(CORE_DATA_FETCH_COMPLETION)completion;
- (oneway void) fetchAllClassicAlbums:(CORE_DATA_FETCH_MANY_COMPLETION)completion;
- (oneway void) fetchAllNewlyReleasedAlbums:(CORE_DATA_FETCH_MANY_COMPLETION)completion;
- (oneway void) fetchAllEventAlbums:(CORE_DATA_FETCH_MANY_COMPLETION)completion;

#pragma mark -
#pragma mark MGMPlaylist

- (oneway void) persistPlaylist:(MGMPlaylistDto*)playlistDto completion:(CORE_DATA_PERSIST_COMPLETION)completion;
- (oneway void) fetchPlaylistWithId:(NSString*)playlistId completion:(CORE_DATA_FETCH_COMPLETION)completion;

#pragma mark -
#pragma mark Threading

- (id) mainThreadVersion:(NSManagedObjectID*)moid;
- (NSArray*) mainThreadVersions:(NSArray*)moids;

@end
