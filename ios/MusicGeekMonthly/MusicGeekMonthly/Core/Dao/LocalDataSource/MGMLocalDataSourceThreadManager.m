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

@property (strong) NSPersistentStoreCoordinator* psc;
@property (strong) NSMutableDictionary* threadUuidsToMocs;

@end

@implementation MGMLocalDataSourceThreadManager

- (id) initWithStoreName:(NSString*)storeName
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadWillExit:) name:NSThreadWillExitNotification object:nil];

        self.threadUuidsToMocs = [NSMutableDictionary dictionary];

        NSError* error = nil;
        self.psc = [self createPersistentStoreCoordinatorWithStoreName:storeName error:&error];
        if (error != nil)
        {
            NSLog(@"Error when creating persistent store coordinator: %@", error);
        }
    }
    return self;
}

- (NSManagedObjectContext*) managedObjectContextForCurrentThread
{
    NSThread* thread = [NSThread currentThread];
    NSMutableDictionary* td = thread.threadDictionary;
    NSString* uuid = [td objectForKey:THREAD_UUID_KEY];
    if (uuid == nil)
    {
        // We've not seen this thread before...
        NSString* uuid = [[NSUUID UUID] UUIDString];
        [td setObject:uuid forKey:THREAD_UUID_KEY];
        NSManagedObjectContext* moc = [self createManagedObjectContextsWithPersistentStoreCoordinator:self.psc];
        @synchronized(self)
        {
            [self.threadUuidsToMocs setObject:moc forKey:uuid];
        }
        return moc;
    }

    return [self.threadUuidsToMocs objectForKey:uuid];
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

- (NSManagedObjectContext*) createManagedObjectContextsWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)psc
{
    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;
    moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return moc;
}

#pragma mark -
#pragma mark NSThreadWillExitNotification

- (void) threadWillExit:(NSNotification*)notification
{
    NSThread* thread = notification.object;
    NSMutableDictionary* td = thread.threadDictionary;
    NSString* uuid = [td objectForKey:THREAD_UUID_KEY];
    if (uuid)
    {
        // This is one of ours...
        @synchronized(self)
        {
            [self.threadUuidsToMocs removeObjectForKey:uuid];
        }
    }
}

@end
