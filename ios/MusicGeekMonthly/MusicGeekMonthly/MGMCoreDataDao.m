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
    [self.managedObjectContext save:error];
    return record;
}

- (MGMWeeklyChart*) createNewWeeklyChart:(NSError**)error
{
    MGMWeeklyChart* chart = [self createNewManagedObjectWithName:@"MGMWeeklyChart" error:error];
    [chart setAlbums:[NSOrderedSet orderedSet]];
    return chart;
}

- (MGMEvent*) createNewEvent:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMEvent" error:error];
}

- (MGMAlbum*) createNewAlbum:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMAlbum" error:error];
}

- (MGMTimePeriod*) createNewMGMTimePeriod:(NSError**)error
{
    return [self createNewManagedObjectWithName:@"MGMTimePeriod" error:error];
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
        return managedObjectContext;
    }
    NSLog(@"Error creating momd: %@", *error);
    return nil;
}

@end
