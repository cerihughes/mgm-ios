//
//  MGMCoreDataDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataDao.h"

#import "MGMCoreDataDaoSync.h"
#import "MGMChartEntry+Relationships.h"
#import "MGMEvent+Relationships.h"
#import "MGMWeeklyChart+Relationships.h"

@interface MGMCoreDataDao ()

@property (strong) NSManagedObjectContext* moc;
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
        NSError* error = nil;
        NSPersistentStoreCoordinator* psc = [self createPersistentStoreCoordinatorWithStoreName:storeName error:&error];
        if (error == nil)
        {
            self.moc = [self createManagedObjectContextWithPersistentStoreCoordinator:psc];
            self.daoSync = [[MGMCoreDataDaoSync alloc] initWithManagedObjectContext:self.moc];
        }
        else
        {
            NSLog(@"Error when creating persistent store coordinator: %@", error);
        }
    }
    return self;
}


- (void) persistTimePeriods:(NSArray*)timePeriodDtos completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        [self.daoSync persistTimePeriods:timePeriodDtos error:&error];
        completion(error);
    }];
}

- (void) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        [self.daoSync persistWeeklyChart:weeklyChartDto error:&error];
        completion(error);
    }];
}

- (void) persistEvents:(NSArray*)eventDtos completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        [self.daoSync persistEvents:eventDtos error:&error];
        completion(error);
    }];
}

- (void) addImageUris:(NSArray*)uriDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        [self.daoSync addImageUris:uriDtos toAlbumWithMbid:mbid updateServiceType:serviceType error:&error];
        completion(error);
    }];
}

- (void) addMetadata:(NSArray*)metadataDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        [self.daoSync addMetadata:metadataDtos toAlbumWithMbid:mbid updateServiceType:serviceType error:&error];
        completion(error);
    }];
}

- (void) fetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        NSArray* timePeriods = [self.daoSync fetchAllTimePeriods:&error];
        completion(timePeriods, error);
    }];
}

- (void) fetchWeeklyChartWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMWeeklyChart* weeklyChart = [self.daoSync fetchWeeklyChartWithStartDate:startDate endDate:endDate error:&error];
        completion(weeklyChart, error);
    }];
}

- (void) fetchChartEntryWithWeeklyChart:(MGMWeeklyChart*)weeklyChart rank:(NSNumber*)rank completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMChartEntry* entry = [self.daoSync fetchChartEntryWithWeeklyChart:weeklyChart rank:rank error:&error];
        completion(entry, error);
    }];
}

- (void) fetchAlbumWithMbid:(NSString*)mbid completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMAlbum* album = [self.daoSync fetchAlbumWithMbid:mbid error:&error];
        completion(album, error);
    }];
}

- (void) fetchAllEvents:(FETCH_MANY_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        NSArray* events = [self.daoSync fetchAllEvents:&error];
        completion(events, error);
    }];
}

- (void) fetchEventWithEventNumber:(NSNumber*)eventNumber completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMEvent* event = [self.daoSync fetchEventWithEventNumber:eventNumber error:&error];
        completion(event, error);
    }];
}

- (NSPersistentStoreCoordinator*) createPersistentStoreCoordinatorWithStoreName:(NSString*)storeName error:(NSError**)error
{
    // Create the managed object model...
    NSString* path = [[NSBundle mainBundle] pathForResource:@"MusicGeekMonthly" ofType:@"momd"];
    NSURL* momURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];

    // Create the persistent store co-ordinator...
    NSString* applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL* storeUrl = [NSURL fileURLWithPath:[applicationDocumentsDirectory stringByAppendingPathComponent:storeName]];
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:error];
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext*) createManagedObjectContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)psc
{
    NSManagedObjectContext* managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = psc;
    managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return managedObjectContext;
}

@end
