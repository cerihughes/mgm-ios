//
//  MGMLocalDataSourceThreadManager.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMLocalDataSourceThreadManager.h"

#define THREAD_UUID_KEY @"MGM_THREAD_UUID_KEY"

@interface MGMLocalDataSourceThreadManager ()

@property (readonly) NSManagedObjectContext* masterMoc;
@property (readonly) NSManagedObjectContext* mainMoc;
@property (readonly) NSManagedObjectContext* backgroundMoc;

@end

@implementation MGMLocalDataSourceThreadManager

- (id) initWithStoreName:(NSString*)storeName
{
    if (self = [super init])
    {
        NSError* error = nil;
        NSPersistentStoreCoordinator* psc = [self createPersistentStoreCoordinatorWithStoreName:storeName error:&error];
        if (error != nil)
        {
            NSLog(@"Error when creating persistent store coordinator: %@", error);
        }

        _masterMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _masterMoc.persistentStoreCoordinator = psc;
        
        _mainMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainMoc.parentContext = _masterMoc;

        _backgroundMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundMoc.parentContext = _mainMoc;
    }
    return self;
}

- (NSManagedObjectContext*) managedObjectContextForCurrentThread
{
    if ([NSThread isMainThread])
    {
        return self.mainMoc;
    }
    else
    {
        return self.backgroundMoc;
    }
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

@end
