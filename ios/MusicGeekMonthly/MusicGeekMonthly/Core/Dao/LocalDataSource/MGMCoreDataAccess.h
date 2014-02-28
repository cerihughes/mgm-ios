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
#import "MGMPlaylist.h"
#import "MGMPlaylistDto.h"
#import "MGMWeeklyChartDto.h"
#import "MGMWeeklyChart.h"

#define MGM_NO_ERROR(_error) (((_error) == nil) || (*(_error) == nil))
#define MGM_ERROR(_error) (((_error) != nil) && (*(_error) != nil))

@interface MGMCoreDataAccess : NSObject

#pragma mark -
#pragma mark MGMNextUrlAccess

- (BOOL) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date error:(NSError**)error;
- (MGMNextUrlAccess*) fetchNextUrlAccessWithIdentifier:(NSString*)identifier error:(NSError**)error;

#pragma mark -
#pragma mark MGMTimePeriod

- (BOOL) persistTimePeriods:(NSArray*)timePeriodDtos error:(NSError**)error;
- (NSFetchedResultsController*) createTimePeriodsFetchedResultsController;
- (NSArray*) fetchAllTimePeriods:(NSError**)error;

#pragma mark -
#pragma mark MGMWeeklyChart

- (BOOL) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto error:(NSError**)error;
- (MGMWeeklyChart*) fetchWeeklyChartWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate error:(NSError**)error;

#pragma mark -
#pragma mark MGMChartEntry

- (MGMChartEntry*) fetchChartEntryWithWeeklyChart:(MGMWeeklyChart*)weeklyChart rank:(NSNumber*)rank error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbum

- (MGMAlbum*) fetchAlbumWithMbid:(NSString*)mbid error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbumImageUri

- (BOOL) addImageUris:(NSArray*)uriDtos toAlbum:(MGMAlbum*)album error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbumMetadata

- (BOOL) addMetadata:(MGMAlbumMetadataDto*)metadataDto toAlbum:(MGMAlbum*)album error:(NSError**)error;

#pragma mark -
#pragma mark MGMEvent

- (BOOL) persistEvents:(NSArray*)eventDtos error:(NSError**)error;
- (NSFetchedResultsController*) createEventsFetchedResultsController;
- (NSArray*) fetchAllEvents:(NSError**)error;
- (MGMEvent*) fetchEventWithEventNumber:(NSNumber*)eventNumber error:(NSError**)error;
- (NSArray*) fetchAllClassicAlbums:(NSError**)error;
- (NSArray*) fetchAllNewlyReleasedAlbums:(NSError**)error;
- (NSArray*) fetchAllEventAlbums:(NSError**)error;

#pragma mark -
#pragma mark MGMPlaylist

- (BOOL) persistPlaylist:(MGMPlaylistDto*)playlistDto error:(NSError**)error;
- (MGMPlaylist*) fetchPlaylistWithId:(NSString*)playlistId error:(NSError**)error;

#pragma mark -
#pragma mark Threading

- (id) threadVersion:(NSManagedObjectID*)moid;

@end
