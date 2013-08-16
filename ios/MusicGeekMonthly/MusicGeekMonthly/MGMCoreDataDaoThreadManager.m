//
//  MGMCoreDataDaoThreadManager.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataDaoThreadManager.h"

#define THREAD_UUID_KEY @"MGMCoreDataDaoThreadManager::THREAD_UUID_KEY"

@interface MGMCoreDataDaoThreadManager ()

@property (strong) NSMutableDictionary* threadUuidsToMocs;
@property (strong) NSPersistentStoreCoordinator* psc;

@end

@implementation MGMCoreDataDaoThreadManager

- (id) init
{
    return [self initWithStoreName:@"MusicGeekMonthly.sqlite"];
}

- (id) initWithStoreName:(NSString*)storeName
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadExiting:) name:NSThreadWillExitNotification object:nil];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSThreadWillExitNotification object:nil];
}

- (NSManagedObjectContext*) managedObjectContextForCurrentThread
{
    NSThread* thread = [NSThread currentThread];
    @synchronized(self)
    {
        NSString* uuid = [thread.threadDictionary objectForKey:THREAD_UUID_KEY];

        NSManagedObjectContext* moc = [self.threadUuidsToMocs objectForKey:uuid];
        if (moc == nil)
        {
            if (uuid == nil)
            {
                uuid = [[NSUUID UUID] UUIDString];
                [thread.threadDictionary setObject:uuid forKey:THREAD_UUID_KEY];
            }

            NSLog(@"Creating new NSManagedObjectContext in thread %@ with UUID %@", thread, uuid);
            moc = [self createManagedObjectContextWithPersistentStoreCoordinator:self.psc];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:moc];

            [self.threadUuidsToMocs setObject:moc forKey:uuid];
        }
        return moc;
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

- (NSManagedObjectContext*) createManagedObjectContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)psc
{
    NSManagedObjectContext* managedObjectContext = [[NSManagedObjectContext alloc] init];
    managedObjectContext.persistentStoreCoordinator = psc;
    managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return managedObjectContext;
}

#pragma mark -
#pragma mark NSThreadWillExitNotification

- (void)threadExiting:(NSNotification*)notification
{
    NSThread* thread = notification.object;
    @synchronized(self)
    {
        NSString* uuid = [thread.threadDictionary objectForKey:THREAD_UUID_KEY];
        if (uuid)
        {
            // This is one of ours...
            NSManagedObjectContext* moc = [self.threadUuidsToMocs objectForKey:uuid];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:moc];

            NSLog(@"Destroying NSManagedObjectContext in thread %@ with UUID %@", thread, uuid);
            [self.threadUuidsToMocs removeObjectForKey:uuid];
        }
    }
}

#pragma mark -
#pragma mark NSManagedObjectContextDidSaveNotification

- (void) managedObjectContextSaveNotification:(NSNotification*)notification
{
    NSManagedObjectContext* changedMoc = notification.object;
    @synchronized(self)
    {
        for (NSManagedObjectContext* moc in [self.threadUuidsToMocs allValues])
        {
            if (moc != changedMoc)
            {
                [moc mergeChangesFromContextDidSaveNotification:notification];
            }
        }
    }
}

@end
