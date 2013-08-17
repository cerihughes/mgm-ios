//
//  MGMCoreDataDaoSync.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>
#import "MGMChartEntry.h"
#import "MGMEvent.h"
#import "MGMNextUrlAccess.h"
#import "MGMTimePeriod.h"
#import "MGMWeeklyChart.h"
#import "MGMWeeklyChartDto.h"

@interface MGMCoreDataDaoSync : NSObject

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

#pragma mark -
#pragma mark MGMNextUrlAccess

- (void) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date error:(NSError**)error;
- (MGMNextUrlAccess*) fetchNextUrlAccessWithIdentifier:(NSString*)identifier error:(NSError**)error;

#pragma mark -
#pragma mark MGMTimePeriod

- (void) persistTimePeriods:(NSArray*)timePeriodDtos error:(NSError**)error;
- (NSArray*) fetchAllTimePeriods:(NSError**)error;

#pragma mark -
#pragma mark MGMWeeklyChart

- (void) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto error:(NSError**)error;
- (MGMWeeklyChart*) fetchWeeklyChartWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate error:(NSError**)error;

#pragma mark -
#pragma mark MGMChartEntry

- (MGMChartEntry*) fetchChartEntryWithWeeklyChart:(MGMWeeklyChart*)weeklyChart rank:(NSNumber*)rank error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbum

- (MGMAlbum*) fetchAlbumWithMbid:(NSString*)mbid error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbumImageUri

- (void) addImageUris:(NSArray*)uriDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType error:(NSError**)error;

#pragma mark -
#pragma mark MGMAlbumMetadata

- (void) addMetadata:(NSArray*)metadataDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType error:(NSError**)error;

#pragma mark -
#pragma mark MGMEvent

- (void) persistEvents:(NSArray*)eventDtos error:(NSError**)error;
- (NSArray*) fetchAllEvents:(NSError**)error;
- (MGMEvent*) fetchEventWithEventNumber:(NSNumber*)eventNumber error:(NSError**)error;

#pragma mark -
#pragma mark #pragma mark Transactional

- (void) commitChanges:(NSError**)error;
- (void) rollbackChanges;

@end
