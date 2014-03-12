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

@interface MGMCoreDataAccess : NSObject

#pragma mark -
#pragma mark MGMNextUrlAccess

- (BOOL) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date error:(NSError**)error;
- (NSManagedObjectID*) fetchNextUrlAccessWithIdentifier:(NSString*)identifier error:(NSError**)error;

#pragma mark -
#pragma mark MGMTimePeriod

- (BOOL) persistTimePeriods:(NSArray*)timePeriodDtos error:(NSError**)error;
- (NSArray*) fetchAllTimePeriods:(NSError**)error;

#pragma mark -
#pragma mark MGMWeeklyChart

- (BOOL) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto error:(NSError**)error;
- (NSManagedObjectID*) fetchWeeklyChartWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbum

- (NSManagedObjectID*) fetchAlbumWithMbid:(NSString*)mbid error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbumImageUri

- (BOOL) addImageUris:(NSArray*)uriDtos toAlbum:(MGMAlbum*)album error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbumMetadata

- (BOOL) addMetadata:(MGMAlbumMetadataDto*)metadataDto toAlbum:(MGMAlbum*)album error:(NSError**)error;

#pragma mark -
#pragma mark MGMEvent

- (BOOL) persistEvents:(NSArray*)eventDtos error:(NSError**)error;
- (NSArray*) fetchAllEvents:(NSError**)error;
- (NSManagedObjectID*) fetchEventWithEventNumber:(NSNumber*)eventNumber error:(NSError**)error;
- (NSArray*) fetchAllClassicAlbums:(NSError**)error;
- (NSArray*) fetchAllNewlyReleasedAlbums:(NSError**)error;
- (NSArray*) fetchAllEventAlbums:(NSError**)error;

#pragma mark -
#pragma mark MGMPlaylist

- (BOOL) persistPlaylist:(MGMPlaylistDto*)playlistDto error:(NSError**)error;
- (NSManagedObjectID*) fetchPlaylistWithId:(NSString*)playlistId error:(NSError**)error;

#pragma mark -
#pragma mark Threading

- (id) threadVersion:(NSManagedObjectID*)moid;
- (NSArray*) threadVersions:(NSArray*)moids;

@end
