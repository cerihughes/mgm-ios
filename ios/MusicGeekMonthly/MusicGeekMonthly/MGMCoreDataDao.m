//
//  MGMCoreDataDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataDao.h"
#import <CoreData/CoreData.h>

@interface MGMCoreDataDao ()

@property (strong) NSManagedObjectContext* managedObjectContext;

@end

@implementation MGMCoreDataDao

- (id) init
{
    if (self = [super init])
    {
        NSError* error = nil;
        self.managedObjectContext = [self createManagedObjectContext:&error];
        // TODO : Deal with error
    }
    return self;
}

- (id) createNewManagedObjectWithName:(NSString*)name error:(NSError**)error;
{
    NSManagedObject* record = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
    [self persistChanges:error];
    return record;
}

- (MGMWeeklyChart*) createNewWeeklyChart:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMWeeklyChart" error:error];
}

- (MGMEvent*) createNewEvent:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMEvent" error:error];
}

- (MGMChartEntry*) createNewChartEntry:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMChartEntry" error:error];
}

- (MGMAlbum*) createNewAlbum:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMAlbum" error:error];
}

- (MGMTimePeriod*) createNewTimePeriod:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMTimePeriod" error:error];
}

- (MGMAlbumImageUri*) createNewAlbumImageUri:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMAlbumImageUri" error:error];
}

- (MGMAlbumMetadata*) createNewAlbumMetadata:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMAlbumMetadata" error:error];
}

- (MGMTimePeriod*) fetchTimePeriod:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMTimePeriod" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMWeeklyChart*) fetchWeeklyChart:(NSDate *)startDate endDate:(NSDate *)endDate error:(NSError *__autoreleasing *)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMWeeklyChart" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMAlbum*) fetchAlbum:(NSString*)albumMbid error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"albumMbid = %@", albumMbid];
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMEvent*) fetchEvent:(NSNumber*)eventNumber error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMEvent" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"eventNumber = %@", eventNumber];
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMAlbumImageUri*) fetchAlbumImageUriForAlbum:(MGMAlbum*)album size:(MGMAlbumImageSize)size error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbumImageUri" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"(album = %@) AND (sizeObject = %d)", album, size];
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMAlbumMetadata*) fetchAlbumMetadataForAlbum:(MGMAlbum*)album serviceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbumMetadata" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"(album = %@) AND (serviceTypeObject = %d)", album, serviceType];
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (void) persistChanges:(NSError**)error
{
    [self.managedObjectContext save:error];
}

- (NSManagedObjectContext*) createManagedObjectContext:(NSError**)error
{
    // Create the managed object model...
    NSString* path = [[NSBundle mainBundle] pathForResource:@"MusicGeekMonthly" ofType:@"momd"];
    NSURL* momURL = [NSURL fileURLWithPath:path];
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];

    // Create the persistent store co-ordinator...
    NSString* applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL* storeUrl = [NSURL fileURLWithPath:[applicationDocumentsDirectory stringByAppendingPathComponent:@"MusicGeekMonthly.sqlite"]];
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if ([persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:error])
    {
        NSManagedObjectContext* managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        return managedObjectContext;
    }
    NSLog(@"Error creating momd: %@", *error);
    return nil;
}

@end
