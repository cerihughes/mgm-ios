//
//  MGMCoreDataDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataDao.h"
#import "MGMCoreDataDaoThreadManager.h"
#import <CoreData/CoreData.h>

@interface MGMCoreDataDao ()

@property (strong) MGMCoreDataDaoThreadManager* mocThreadManager;

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
        self.mocThreadManager = [[MGMCoreDataDaoThreadManager alloc] init];
    }
    return self;
}

- (id) createNewManagedObjectWithName:(NSString*)name error:(NSError**)error;
{
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    NSManagedObject* record = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:moc];
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
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    request.entity = [NSEntityDescription entityForName:@"MGMTimePeriod" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMWeeklyChart*) fetchWeeklyChart:(NSDate *)startDate endDate:(NSDate *)endDate error:(NSError *__autoreleasing *)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    request.entity = [NSEntityDescription entityForName:@"MGMWeeklyChart" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMAlbum*) fetchAlbum:(NSString*)albumMbid error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"albumMbid = %@", albumMbid];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMEvent*) fetchEvent:(NSNumber*)eventNumber error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    request.entity = [NSEntityDescription entityForName:@"MGMEvent" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"eventNumber = %@", eventNumber];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMAlbum*) album:(MGMAlbum*)album forManagedObjectContext:(NSManagedObjectContext*)moc error:(NSError**)error
{
    if (album.managedObjectContext == moc)
    {
        return album;
    }
    return [self fetchAlbum:album.albumMbid error:error];
}

- (MGMAlbumImageUri*) fetchAlbumImageUriForAlbum:(MGMAlbum*)album size:(MGMAlbumImageSize)size error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    album = [self album:album forManagedObjectContext:moc error:error];
    if (error && *error != nil)
    {
        return nil;
    }

    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbumImageUri" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(album = %@) AND (sizeObject = %d)", album, size];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMAlbumMetadata*) fetchAlbumMetadataForAlbum:(MGMAlbum*)album serviceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    album = [self album:album forManagedObjectContext:moc error:error];
    if (error && *error != nil)
    {
        return nil;
    }

    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbumMetadata" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(album = %@) AND (serviceTypeObject = %d)", album, serviceType];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (void) persistChanges:(NSError**)error
{
    NSManagedObjectContext* moc = [self.mocThreadManager managedObjectContextForCurrentThread];
    [moc save:error];
}

@end
