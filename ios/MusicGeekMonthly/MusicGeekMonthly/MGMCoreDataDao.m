//
//  MGMCoreDataDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataDao.h"

#import "MGMCoreDataDaoSync.h"
#import "MGMCoreDataThreadManager.h"

@interface MGMCoreDataDao ()

@property (strong) MGMCoreDataThreadManager* threadManager;
@property (readonly) NSManagedObjectContext* moc;
@property (strong) MGMCoreDataDaoSync* daoSync;

@end

@implementation MGMCoreDataDao

- (id) init
{
    return [self initWithStoreName:@"MusicGeekMonthly.sqlite"];
}

- (id) initWithStoreName:(NSString*)storeName
{
    if (self = [super init])
    {
        self.threadManager = [[MGMCoreDataThreadManager alloc] initWithStoreName:storeName];
        self.daoSync = [[MGMCoreDataDaoSync alloc] initWithThreadManager:self.threadManager];
    }
    return self;
}

- (NSManagedObjectContext*) moc
{
    return [self.threadManager managedObjectContextForCurrentThread];
}

- (void) persistNextUrlAccess:(NSString*)identifier date:(NSDate*)date completion:(VOID_COMPLETION)completion
{
    NSError* error = nil;
    [self.daoSync persistNextUrlAccess:identifier date:date error:&error];
    completion(error);
}

- (void) persistTimePeriods:(NSArray*)timePeriodDtos completion:(VOID_COMPLETION)completion
{
    NSError* error = nil;
    [self.daoSync persistTimePeriods:timePeriodDtos error:&error];
    completion(error);
}

- (void) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto completion:(VOID_COMPLETION)completion
{
    NSError* error = nil;
    [self.daoSync persistWeeklyChart:weeklyChartDto error:&error];
    completion(error);
}

- (void) persistEvents:(NSArray*)eventDtos completion:(VOID_COMPLETION)completion
{
    NSError* error = nil;
    [self.daoSync persistEvents:eventDtos error:&error];
    completion(error);
}

- (void) addImageUris:(NSArray*)uriDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType completion:(VOID_COMPLETION)completion
{
    NSError* error = nil;
    [self.daoSync addImageUris:uriDtos toAlbumWithMbid:mbid updateServiceType:serviceType error:&error];
    completion(error);
}

- (void) addMetadata:(NSArray*)metadataDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType completion:(VOID_COMPLETION)completion
{
    NSError* error = nil;
    [self.daoSync addMetadata:metadataDtos toAlbumWithMbid:mbid updateServiceType:serviceType error:&error];
    completion(error);
}

- (MGMNextUrlAccess*) fetchNextUrlAccessWithIdentifier:(NSString*)identifer error:(NSError**)error
{
    return [self.daoSync fetchNextUrlAccessWithIdentifier:identifer error:error];
}

- (void) fetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    NSError* error = nil;
    NSArray* timePeriods = [self.daoSync fetchAllTimePeriods:&error];
    completion(timePeriods, error);
}

- (void) fetchWeeklyChartWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion
{
    NSError* error = nil;
    MGMWeeklyChart* weeklyChart = [self.daoSync fetchWeeklyChartWithStartDate:startDate endDate:endDate error:&error];
    completion(weeklyChart, error);
}

- (void) fetchChartEntryWithWeeklyChart:(MGMWeeklyChart*)weeklyChart rank:(NSNumber*)rank completion:(FETCH_COMPLETION)completion
{
    NSError* error = nil;
    MGMChartEntry* entry = [self.daoSync fetchChartEntryWithWeeklyChart:weeklyChart rank:rank error:&error];
    completion(entry, error);
}

- (void) fetchAlbumWithMbid:(NSString*)mbid completion:(FETCH_COMPLETION)completion
{
    NSError* error = nil;
    MGMAlbum* album = [self.daoSync fetchAlbumWithMbid:mbid error:&error];
    completion(album, error);
}

- (void) fetchAllEvents:(FETCH_MANY_COMPLETION)completion
{
    NSError* error = nil;
    NSArray* events = [self.daoSync fetchAllEvents:&error];
    completion(events, error);
}

- (void) fetchEventWithEventNumber:(NSNumber*)eventNumber completion:(FETCH_COMPLETION)completion
{
    NSError* error = nil;
    MGMEvent* event = [self.daoSync fetchEventWithEventNumber:eventNumber error:&error];
    completion(event, error);
}

- (id) threadVersion:(NSManagedObjectID *)moid
{
    return [self.moc objectWithID:moid];
}

- (NSFetchedResultsController*) createTimePeriodsFetchedResultsController
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [self.daoSync timePeriodsFetchRequest];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"groupHeader" cacheName:@"Root"];
}

- (NSFetchedResultsController*) createEventsFetchedResultsController
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [self.daoSync eventsFetchRequest];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"groupHeader" cacheName:@"Root"];
}

@end
