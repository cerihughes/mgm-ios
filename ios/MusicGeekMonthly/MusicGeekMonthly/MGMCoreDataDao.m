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

@property (strong) NSManagedObjectContext* moc;

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
        }
        else
        {
            NSLog(@"Error when creating persistent store coordinator: %@", error);
        }
    }
    return self;
}

- (void) createNewManagedObjectWithName:(NSString*)name completion:(CREATION_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSManagedObject* record = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.moc];
        NSError* error = nil;
        completion(record, error);
    }];
}

- (void) createNewTimePeriodForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(CREATION_COMPLETION)completion
{
    [self createNewManagedObjectWithName:@"MGMTimePeriod" completion:^(MGMTimePeriod* timePeriod, NSError* creationError)
    {
        timePeriod.startDate = startDate;
        timePeriod.endDate = endDate;
        completion(timePeriod, creationError);
    }];
}

- (void) createNewWeeklyChartForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(CREATION_COMPLETION)completion
{
    [self createNewManagedObjectWithName:@"MGMWeeklyChart" completion:^(MGMWeeklyChart* chart, NSError* creationError)
    {
        chart.startDate = startDate;
        chart.endDate = endDate;
        completion(chart, creationError);
    }];
}

- (void) createNewChartEntryForRank:(NSNumber*)rank listeners:(NSNumber*)listeners completion:(CREATION_COMPLETION)completion
{
    [self createNewManagedObjectWithName:@"MGMChartEntry" completion:^(MGMChartEntry* entry, NSError* creationError)
    {
        entry.rank = rank;
        entry.listeners = listeners;
        completion(entry, creationError);
    }];
}

- (void) createNewAlbumForMbid:(NSString*)mbid artistName:(NSString*)artistName albumName:(NSString*)albumName score:(NSNumber*)score completion:(CREATION_COMPLETION)completion
{
    [self createNewManagedObjectWithName:@"MGMAlbum" completion:^(MGMAlbum* album, NSError* creationError)
    {
        album.albumMbid = mbid;
        album.artistName = artistName;
        album.albumName = albumName;
        album.score = score;
        completion(album, creationError);
    }];
}

- (void) createNewAlbumImageUriForSize:(MGMAlbumImageSize)size uri:(NSString*)uri completion:(CREATION_COMPLETION)completion
{
    [self createNewManagedObjectWithName:@"MGMAlbumImageUri" completion:^(MGMAlbumImageUri* uriObject, NSError* creationError)
    {
        uriObject.size = size;
        uriObject.uri = uri;
        completion(uriObject, creationError);
    }];
}

- (void) createNewAlbumMetadataForServiceType:(MGMAlbumServiceType)serviceType value:(NSString*)value completion:(CREATION_COMPLETION)completion
{
    [self createNewManagedObjectWithName:@"MGMAlbumMetadata" completion:^(MGMAlbumMetadata* metadata, NSError* creationError)
    {
        metadata.serviceType = serviceType;
        metadata.value = value;
        completion(metadata, creationError);
    }];
}

- (void) createNewEventForEventNumber:(NSNumber*)eventNumber eventDate:(NSDate*)eventDate playlistId:(NSString*)playlistId completion:(CREATION_COMPLETION)completion
{
    [self createNewManagedObjectWithName:@"MGMEvent" completion:^(MGMEvent* event, NSError* creationError)
    {
        event.eventNumber = eventNumber;
        event.eventDate = eventDate;
        event.spotifyPlaylistId = playlistId;
        completion(event, creationError);
    }];
}

- (void) fetchAllTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        NSArray* timePeriods = [self fetchTimePeriods:&error];
        completion(timePeriods, error);
    }];
}

- (MGMTimePeriod*) fetchTimePeriod:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMTimePeriod" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (NSArray*) fetchTimePeriods:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMTimePeriod" inManagedObjectContext:self.moc];
    return [self.moc executeFetchRequest:request error:error];
}

- (void) fetchWeeklyChart:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMWeeklyChart* weeklyChart = [self fetchWeeklyChart:startDate endDate:endDate error:&error];
        completion(weeklyChart, error);
    }];
}

- (MGMWeeklyChart*) fetchWeeklyChart:(NSDate *)startDate endDate:(NSDate *)endDate error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMWeeklyChart" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (void) fetchAlbum:(NSString*)albumMbid completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMAlbum* album = [self fetchAlbum:albumMbid error:&error];
        completion(album, error);
    }];
}

- (MGMAlbum*) fetchAlbum:(NSString*)albumMbid error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"albumMbid = %@", albumMbid];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (void) fetchEvent:(NSNumber*)eventNumber completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMEvent* event = [self fetchEvent:eventNumber error:&error];
        completion(event, error);
    }];
}

- (MGMEvent*) fetchEvent:(NSNumber*)eventNumber error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMEvent" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"eventNumber = %@", eventNumber];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (void) fetchAlbumImageUriForAlbum:(MGMAlbum*)album size:(MGMAlbumImageSize)size completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMAlbumImageUri* uri = [self fetchAlbumImageUriForAlbum:album size:size error:&error];
        completion(uri, error);
    }];
}

- (MGMAlbumImageUri*) fetchAlbumImageUriForAlbum:(MGMAlbum*)album size:(MGMAlbumImageSize)size error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbumImageUri" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(album = %@) AND (sizeObject = %d)", album, size];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (void) fetchAlbumMetadataForAlbum:(MGMAlbum*)album serviceType:(MGMAlbumServiceType)serviceType completion:(FETCH_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        MGMAlbumMetadata* metadata = [self fetchAlbumMetadataForAlbum:album serviceType:serviceType error:&error];
        completion(metadata, error);
    }];
}

- (MGMAlbumMetadata*) fetchAlbumMetadataForAlbum:(MGMAlbum*)album serviceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbumMetadata" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(album = %@) AND (serviceTypeObject = %d)", album, serviceType];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (void) addTimePeriods:(NSDictionary*)periods completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        __block NSError* finalError = nil;
        [periods enumerateKeysAndObjectsUsingBlock:^(NSDate* startDate, NSDate* endDate, BOOL *stop)
        {
            NSError* error = nil;
            __block MGMTimePeriod* timePeriod = [self fetchTimePeriod:startDate endDate:endDate error:&error];
            if (error == nil)
            {
                if (timePeriod == nil)
                {
                    [self.moc performBlockAndWait:^
                    {
                        timePeriod = [NSEntityDescription insertNewObjectForEntityForName:@"MGMTimePeriod" inManagedObjectContext:self.moc];
                    }];
                }
            }
            else
            {
                finalError = error;
            }
        }];
        completion(finalError);
    }];
}

- (void) addImageUris:(NSDictionary*)uris toAlbum:(MGMAlbum*)album completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        __block NSError* finalError = nil;
        [uris enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, NSString* obj, BOOL *stop)
        {
            NSError* error = nil;
            MGMAlbumImageSize size = key.integerValue;
            __block MGMAlbumImageUri* uri = [self fetchAlbumImageUriForAlbum:album size:size error:&error];
            if (error == nil)
            {
                if (uri == nil)
                {
                    [self.moc performBlockAndWait:^
                    {
                        uri = [NSEntityDescription insertNewObjectForEntityForName:@"MGMAlbumImageUri" inManagedObjectContext:self.moc];
                        uri.size = size;
                    }];
                }
                uri.uri = obj;
            }
            else
            {
                finalError = error;
            }
        }];
        completion(finalError);
    }];
}

- (void) addMetadata:(NSDictionary*)metadata toAlbum:(MGMAlbum*)album completion:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        __block NSError* finalError = nil;
        [metadata enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, NSString* obj, BOOL *stop)
        {
            NSError* error = nil;
            MGMAlbumServiceType serviceType = key.integerValue;
            __block MGMAlbumMetadata* metadata = [self fetchAlbumMetadataForAlbum:album serviceType:serviceType error:&error];
            if (error == nil)
            {
                if (metadata == nil)
                {
                    [self.moc performBlockAndWait:^
                    {
                        metadata = [NSEntityDescription insertNewObjectForEntityForName:@"MGMAlbumMetadata" inManagedObjectContext:self.moc];
                        metadata.serviceType = serviceType;
                    }];
                }
                metadata.value = obj;
            }
            else
            {
                finalError = error;
            }
        }];
    }];
}

- (void) persistChanges:(VOID_COMPLETION)completion
{
    [self.moc performBlock:^
    {
        NSError* error = nil;
        [self.moc save:&error];
        completion(error);
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
