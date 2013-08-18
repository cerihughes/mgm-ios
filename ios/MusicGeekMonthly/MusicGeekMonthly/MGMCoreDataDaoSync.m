//
//  MGMCoreDataDaoSync.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataDaoSync.h"

#import "MGMAlbum+Relationships.h"
#import "MGMAlbumDto.h"
#import "MGMAlbumImageUriDto.h"
#import "MGMAlbumMetadataDto.h"
#import "MGMChartEntry+Relationships.h"
#import "MGMChartEntryDto.h"
#import "MGMEvent+Relationships.h"
#import "MGMEventDto.h"
#import "MGMTimePeriodDto.h"
#import "MGMWeeklyChart+Relationships.h"

@interface MGMCoreDataDaoSync ()

@property (strong) NSManagedObjectContext* moc;

@end

@implementation MGMCoreDataDaoSync

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    if (self = [super init])
    {
        self.moc = managedObjectContext;
    }
    return self;
}

- (id) createNewManagedObjectWithName:(NSString*)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.moc];
}

#pragma mark -
#pragma mark MGMNextUrlAccess

- (void) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date error:(NSError**)error
{
    MGMNextUrlAccess* nextUrlAccess = [self fetchNextUrlAccessWithIdentifier:identifier error:error];
    if (error && *error != nil)
    {
        [self rollbackChanges];
        return;
    }

    if (nextUrlAccess == nil)
    {
        nextUrlAccess = [self createNewNextUrlAccess];
        nextUrlAccess.identifier = identifier;
    }

    nextUrlAccess.date = date;

    [self commitChanges:error];
}

- (MGMNextUrlAccess*) createNewNextUrlAccess
{
    return [self createNewManagedObjectWithName:@"MGMNextUrlAccess"];
}

- (MGMNextUrlAccess*) fetchNextUrlAccessWithIdentifier:(NSString*)identifier error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMNextUrlAccess" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMTimePeriod

- (void) persistTimePeriods:(NSArray*)timePeriodDtos error:(NSError**)error
{
    for (MGMTimePeriodDto* timePeriodDto in timePeriodDtos)
    {
        MGMTimePeriod* timePeriod = [self fetchTimePeriodWithStartDate:timePeriodDto.startDate endDate:timePeriodDto.endDate error:error];
        if (error && *error != nil)
        {
            [self rollbackChanges];
            return;
        }
        
        if (timePeriod == nil)
        {
            timePeriod = [self createNewTimePeriod];
            timePeriod.startDate = timePeriodDto.startDate;
            timePeriod.endDate = timePeriodDto.endDate;
        }
    }
    [self commitChanges:error];
}

- (MGMTimePeriod*) createNewTimePeriod
{
    return [self createNewManagedObjectWithName:@"MGMTimePeriod"];
}

- (NSArray*) fetchAllTimePeriods:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMTimePeriod" inManagedObjectContext:self.moc];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    return [self.moc executeFetchRequest:request error:error];
}

- (MGMTimePeriod*) fetchTimePeriodWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
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

#pragma mark -
#pragma mark MGMWeeklyChart

- (void) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto error:(NSError**)error
{
    MGMWeeklyChart* weeklyChart = [self fetchWeeklyChartWithStartDate:weeklyChartDto.startDate endDate:weeklyChartDto.endDate error:error];
    if (error && *error != nil)
    {
        [self rollbackChanges];
        return;
    }
    
    if (weeklyChart == nil)
    {
        weeklyChart = [self createNewWeeklyChart];
        weeklyChart.startDate = weeklyChartDto.startDate;
        weeklyChart.endDate = weeklyChartDto.endDate;
    }

    for (MGMChartEntryDto* chartEntryDto in weeklyChartDto.chartEntries)
    {
        MGMChartEntry* chartEntry = [self fetchChartEntryWithWeeklyChart:weeklyChart rank:chartEntryDto.rank error:error];
        if (error && *error != nil)
        {
            [self rollbackChanges];
            return;
        }

        if (chartEntry == nil)
        {
            chartEntry = [self createNewChartEntry];
            chartEntry.rank = chartEntryDto.rank;
            [weeklyChart addChartEntriesObject:chartEntry];
        }

        chartEntry.listeners = chartEntryDto.listeners;

        MGMAlbumDto* albumDto = chartEntryDto.album;
        MGMAlbum* album = [self persistAlbumDto:albumDto error:error];
        if (error && *error != nil)
        {
            [self rollbackChanges];
            return;
        }

        chartEntry.album = album;
    }

    [self commitChanges:error];
}

- (MGMWeeklyChart*) createNewWeeklyChart
{
    return [self createNewManagedObjectWithName:@"MGMWeeklyChart"];
}

- (MGMWeeklyChart*) fetchWeeklyChartWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
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

#pragma mark -
#pragma mark MGMChartEntry

- (MGMChartEntry*) createNewChartEntry
{
    return [self createNewManagedObjectWithName:@"MGMChartEntry"];
}

- (MGMChartEntry*) fetchChartEntryWithWeeklyChart:(MGMWeeklyChart*)weeklyChart rank:(NSNumber*)rank error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMChartEntry" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(weeklyChart = %@) AND (rank = %@)", weeklyChart, rank];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMAlbum

- (MGMAlbum*) persistAlbumDto:(MGMAlbumDto*)albumDto error:(NSError**)error
{
    MGMAlbum* album = [self fetchAlbumWithMbid:albumDto.albumMbid error:error];
    if (error && *error != nil)
    {
        return nil;
    }

    if (album == nil)
    {
        album = [self createNewAlbum];
        album.albumMbid = albumDto.albumMbid;
    }

    album.artistName = albumDto.artistName;
    album.albumName = albumDto.albumName;
    album.score = albumDto.score;

    [self addImageUris:albumDto.imageUris toAlbum:album error:error];
    if (error && *error != nil)
    {
        return nil;
    }

    [self addMetadata:albumDto.metadata toAlbum:album error:error];
    if (error && *error != nil)
    {
        return nil;
    }

    return album;
}

- (MGMAlbum*) createNewAlbum
{
    return [self createNewManagedObjectWithName:@"MGMAlbum"];
}

- (MGMAlbum*) fetchAlbumWithMbid:(NSString*)mbid error:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:self.moc];
    request.predicate = [NSPredicate predicateWithFormat:@"albumMbid = %@", mbid];
    NSArray* results = [self.moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMAlbumImageUri

- (void) addImageUris:(NSArray*)uriDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
{
    MGMAlbum* album = [self fetchAlbumWithMbid:mbid error:error];
    if (error && *error != nil)
    {
        [self rollbackChanges];
        return;
    }

    [album setServiceTypeSearched:serviceType];
    
    [self addImageUris:uriDtos toAlbum:album error:error];
    if (error && *error != nil)
    {
        [self rollbackChanges];
        return;
    }

    [self commitChanges:error];
}

- (void) addImageUris:(NSArray*)uriDtos toAlbum:(MGMAlbum*)album error:(NSError**)error
{
    for (MGMAlbumImageUriDto* uriDto in uriDtos)
    {
        MGMAlbumImageUri* uri = [self fetchAlbumImageUriWithAlbum:album size:uriDto.size error:error];
        if (error && *error != nil)
        {
            return;
        }

        if (uri == nil)
        {
            uri = [self createNewAlbumImageUri];
            uri.size = uriDto.size;
            [album addImageUrisObject:uri];
        }
        
        uri.uri = uriDto.uri;
    }
}

- (MGMAlbumImageUri*) createNewAlbumImageUri
{
    return [self createNewManagedObjectWithName:@"MGMAlbumImageUri"];
}

- (MGMAlbumImageUri*) fetchAlbumImageUriWithAlbum:(MGMAlbum*)album size:(MGMAlbumImageSize)size error:(NSError**)error
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

#pragma mark -
#pragma mark MGMAlbumMetadata

- (void) addMetadata:(NSArray*)metadataDtos toAlbumWithMbid:(NSString*)mbid updateServiceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
{
    MGMAlbum* album = [self fetchAlbumWithMbid:mbid error:error];
    if (error && *error != nil)
    {
        [self rollbackChanges];
        return;
    }

    [album setServiceTypeSearched:serviceType];
    
    [self addMetadata:metadataDtos toAlbum:album error:error];
    if (error && *error != nil)
    {
        [self rollbackChanges];
        return;
    }

    [self commitChanges:error];
}

- (void) addMetadata:(NSArray*)metadataDtos toAlbum:(MGMAlbum*)album error:(NSError**)error
{
    for (MGMAlbumMetadataDto* metadataDto in metadataDtos)
    {
        MGMAlbumMetadata* metadata = [self fetchAlbumMetadataWithAlbum:album serviceType:metadataDto.serviceType error:error];
        if (error && *error != nil)
        {
            return;
        }

        if (metadata == nil)
        {
            metadata = [self createNewAlbumMetadata];
            metadata.serviceType = metadataDto.serviceType;
            [album addMetadataObject:metadata];
        }

        metadata.value = metadataDto.value;
    }
}

- (MGMAlbumMetadata*) createNewAlbumMetadata
{
    return [self createNewManagedObjectWithName:@"MGMAlbumMetadata"];
}

- (MGMAlbumMetadata*) fetchAlbumMetadataWithAlbum:(MGMAlbum*)album serviceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
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

#pragma mark -
#pragma mark MGMEvent

- (void) persistEvents:(NSArray*)eventDtos error:(NSError**)error
{
    for (MGMEventDto* eventDto in eventDtos)
    {
        MGMEvent* event = [self fetchEventWithEventNumber:eventDto.eventNumber error:error];
        if (error && *error != nil)
        {
            [self rollbackChanges];
            return;
        }

        if (event == nil)
        {
            event = [self createNewEvent];
            event.eventNumber = eventDto.eventNumber;
        }

        event.eventDate = eventDto.eventDate;
        event.spotifyPlaylistId = eventDto.spotifyPlaylistId;

        MGMAlbumDto* classicAlbumDto = eventDto.classicAlbum;
        MGMAlbum* classicAlbum = [self persistAlbumDto:classicAlbumDto error:error];
        if (error && *error != nil)
        {
            [self rollbackChanges];
            return;
        }

        event.classicAlbum = classicAlbum;

        MGMAlbumDto* newlyReleaseAlbumDto = eventDto.newlyReleasedAlbum;
        MGMAlbum* newlyReleasedAlbum = [self persistAlbumDto:newlyReleaseAlbumDto error:error];
        if (error && *error != nil)
        {
            [self rollbackChanges];
            return;
        }

        event.newlyReleasedAlbum = newlyReleasedAlbum;
    }

    [self commitChanges:error];
}

- (MGMEvent*) createNewEvent
{
    return [self createNewManagedObjectWithName:@"MGMEvent"];
}

- (NSArray*) fetchAllEvents:(NSError**)error
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMEvent" inManagedObjectContext:self.moc];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"eventNumber" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    return [self.moc executeFetchRequest:request error:error];
}

- (MGMEvent*) fetchEventWithEventNumber:(NSNumber*)eventNumber error:(NSError**)error
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

#pragma mark -
#pragma mark Transactional

- (void) commitChanges:(NSError**)error
{
    [self.moc save:error];
}

- (void) rollbackChanges
{
    [self.moc rollback];
}

@end
