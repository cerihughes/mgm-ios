//
//  MGMCoreDataAccess.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataAccess.h"

#import "MGMAlbum.h"
#import "MGMAlbumDto.h"
#import "MGMAlbumImageUri.h"
#import "MGMAlbumImageUriDto.h"
#import "MGMAlbumMetadata.h"
#import "MGMChartEntry.h"
#import "MGMChartEntryDto.h"
#import "MGMEvent.h"
#import "MGMEventDto.h"
#import "MGMLastFmConstants.h"
#import "MGMTimePeriod.h"
#import "MGMTimePeriodDto.h"
#import "MGMWeeklyChart.h"

@interface MGMCoreDataAccess ()

@property (readonly) MGMLocalDataSourceThreadManager* threadManager;

@end

@implementation MGMCoreDataAccess

- (id) init
{
    return [self initWithStoreName:@"MusicGeekMonthly2.sqlite"];
}

- (id) initWithStoreName:(NSString*)storeName
{
    if (self = [super init])
    {
        _threadManager = [[MGMLocalDataSourceThreadManager alloc] initWithStoreName:storeName];
    }
    return self;
}

- (id) createNewManagedObjectWithName:(NSString*)name
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:moc];
}

#pragma mark -
#pragma mark MGMNextUrlAccess

- (BOOL) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date error:(NSError**)error
{
    MGMNextUrlAccess* nextUrlAccess = [self fetchNextUrlAccessWithIdentifier:identifier error:error];
    if (MGM_ERROR(error))
    {
        return [self rollbackChanges];
    }

    if (nextUrlAccess == nil)
    {
        nextUrlAccess = [self createNewNextUrlAccess];
        nextUrlAccess.identifier = identifier;
    }

    nextUrlAccess.date = date;

    return [self commitChanges:error];
}

- (MGMNextUrlAccess*) createNewNextUrlAccess
{
    return [self createNewManagedObjectWithName:@"MGMNextUrlAccess"];
}

- (MGMNextUrlAccess*) fetchNextUrlAccessWithIdentifier:(NSString*)identifier error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMNextUrlAccess" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMTimePeriod

- (BOOL) persistTimePeriods:(NSArray*)timePeriodDtos error:(NSError**)error
{
    for (MGMTimePeriodDto* timePeriodDto in timePeriodDtos)
    {
        MGMTimePeriod* timePeriod = [self fetchTimePeriodWithStartDate:timePeriodDto.startDate endDate:timePeriodDto.endDate error:error];
        if (MGM_ERROR(error))
        {
            return [self rollbackChanges];
        }

        if (timePeriod == nil)
        {
            timePeriod = [self createNewTimePeriod];
            timePeriod.startDate = timePeriodDto.startDate;
            timePeriod.endDate = timePeriodDto.endDate;
        }
    }
    return [self commitChanges:error];
}

- (MGMTimePeriod*) createNewTimePeriod
{
    return [self createNewManagedObjectWithName:@"MGMTimePeriod"];
}

- (NSFetchRequest*) timePeriodsFetchRequest
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMTimePeriod" inManagedObjectContext:moc];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    return request;
}

- (NSFetchedResultsController*) createTimePeriodsFetchedResultsController
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [self timePeriodsFetchRequest];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"groupHeader" cacheName:@"Root"];
}

- (NSArray*) fetchAllTimePeriods:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [self timePeriodsFetchRequest];
    return [moc executeFetchRequest:request error:error];
}

- (MGMTimePeriod*) fetchTimePeriodWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMTimePeriod" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMWeeklyChart

- (BOOL) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto error:(NSError**)error
{
    MGMWeeklyChart* weeklyChart = [self fetchWeeklyChartWithStartDate:weeklyChartDto.startDate endDate:weeklyChartDto.endDate error:error];
    if (MGM_ERROR(error))
    {
        return [self rollbackChanges];
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
        if (MGM_ERROR(error))
        {
            return [self rollbackChanges];
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

        if (MGM_ERROR(error))
        {
            return [self rollbackChanges];
        }

        chartEntry.album = album;
    }

    return [self commitChanges:error];
}

- (MGMWeeklyChart*) createNewWeeklyChart
{
    return [self createNewManagedObjectWithName:@"MGMWeeklyChart"];
}

- (MGMWeeklyChart*) fetchWeeklyChartWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMWeeklyChart" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    NSArray* results = [moc executeFetchRequest:request error:error];
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
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMChartEntry" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(weeklyChart = %@) AND (rank = %@)", weeklyChart, rank];
    NSArray* results = [moc executeFetchRequest:request error:error];
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
    MGMAlbum* album = nil;
    NSString* mbid = albumDto.albumMbid;
    if (mbid && ![mbid hasPrefix:FAKE_MBID_PREPEND])
    {
        album = [self fetchAlbumWithMbid:albumDto.albumMbid error:error];
    }
    else
    {
        album = [self fetchAlbumWithArtistName:albumDto.artistName albumName:albumDto.albumName error:error];
    }

    if (MGM_ERROR(error))
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
    if (albumDto.score)
    {
        album.score = albumDto.score;
    }

    [self internal_addImageUris:albumDto.imageUris toAlbum:album error:error];
    if (MGM_ERROR(error))
    {
        return nil;
    }

    [self internal_addMetadata:albumDto.metadata toAlbum:album error:error];
    if (MGM_ERROR(error))
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
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"albumMbid = %@", mbid];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (MGMAlbum*) fetchAlbumWithArtistName:(NSString*)artistName albumName:(NSString*)albumName error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(artistName = %@) AND (albumName = %@)", artistName, albumName];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMAlbumImageUri

- (BOOL) addImageUris:(NSArray*)uriDtos toAlbum:(MGMAlbum*)album error:(NSError**)error
{
    [self internal_addImageUris:uriDtos toAlbum:album error:error];
    if (MGM_ERROR(error))
    {
        return [self rollbackChanges];
    }

    return [self commitChanges:error];
}

- (void) internal_addImageUris:(NSArray*)uriDtos toAlbum:(MGMAlbum*)album error:(NSError**)error
{
    for (MGMAlbumImageUriDto* uriDto in uriDtos)
    {
        MGMAlbumImageUri* uri = [self fetchAlbumImageUriWithAlbum:album size:uriDto.size error:error];
        if (MGM_ERROR(error))
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
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
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

#pragma mark -
#pragma mark MGMAlbumMetadata

- (BOOL) addMetadata:(MGMAlbumMetadataDto*)metadataDto toAlbum:(MGMAlbum*)album error:(NSError**)error
{
    [album setServiceTypeSearched:metadataDto.serviceType];

    [self internal_addMetadata:@[metadataDto] toAlbum:album error:error];
    if (MGM_ERROR(error))
    {
        return [self rollbackChanges];
    }

    return [self commitChanges:error];
}

- (void) internal_addMetadata:(NSArray*)metadataDtos toAlbum:(MGMAlbum*)album error:(NSError**)error
{
    for (MGMAlbumMetadataDto* metadataDto in metadataDtos)
    {
        MGMAlbumMetadata* metadata = [self fetchAlbumMetadataWithAlbum:album serviceType:metadataDto.serviceType error:error];
        if (MGM_ERROR(error))
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
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
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

#pragma mark -
#pragma mark MGMEvent

- (BOOL) persistEvents:(NSArray*)eventDtos error:(NSError**)error
{
    for (MGMEventDto* eventDto in eventDtos)
    {
        MGMEvent* event = [self fetchEventWithEventNumber:eventDto.eventNumber error:error];
        if (MGM_ERROR(error))
        {
            return [self rollbackChanges];
        }

        if (event == nil)
        {
            event = [self createNewEvent];
            event.eventNumber = eventDto.eventNumber;
        }

        event.eventDate = eventDto.eventDate;
        event.spotifyPlaylistId = eventDto.spotifyPlaylistId;

        MGMAlbumDto* classicAlbumDto = eventDto.classicAlbum;
        if (classicAlbumDto)
        {
            MGMAlbum* classicAlbum = [self persistAlbumDto:classicAlbumDto error:error];
            if (MGM_ERROR(error))
            {
                return [self rollbackChanges];
            }
            event.classicAlbum = classicAlbum;
        }

        MGMAlbumDto* newlyReleaseAlbumDto = eventDto.newlyReleasedAlbum;
        if (newlyReleaseAlbumDto)
        {
            MGMAlbum* newlyReleasedAlbum = [self persistAlbumDto:newlyReleaseAlbumDto error:error];
            if (MGM_ERROR(error))
            {
                return [self rollbackChanges];
            }
            event.newlyReleasedAlbum = newlyReleasedAlbum;
        }
    }

    return [self commitChanges:error];
}

- (MGMEvent*) createNewEvent
{
    return [self createNewManagedObjectWithName:@"MGMEvent"];
}

- (NSFetchRequest*) eventsFetchRequest
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMEvent" inManagedObjectContext:moc];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"eventNumber" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    return request;
}

- (NSFetchedResultsController*) createEventsFetchedResultsController
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [self eventsFetchRequest];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"groupHeader" cacheName:@"Root"];
}

- (NSArray*) fetchAllEvents:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [self eventsFetchRequest];
    return [moc executeFetchRequest:request error:error];
}

- (MGMEvent*) fetchEventWithEventNumber:(NSNumber*)eventNumber error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMEvent" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"eventNumber = %@", eventNumber];
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (NSArray*) fetchAllClassicAlbums:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(classicAlbumEvent != nil) AND (score != nil) AND (score > 0)"];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    return [moc executeFetchRequest:request error:error];
}

- (NSArray*) fetchAllNewlyReleasedAlbums:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(newlyReleasedAlbumEvent != nil) AND (score != nil) AND (score > 0)"];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    return [moc executeFetchRequest:request error:error];
}

- (NSArray*) fetchAllEventAlbums:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGMAlbum" inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"((newlyReleasedAlbumEvent != nil) OR (classicAlbumEvent != nil)) AND (score != nil) AND (score > 0)"];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    return [moc executeFetchRequest:request error:error];
}

#pragma mark -
#pragma mark Transactional

- (BOOL) commitChanges:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    [moc save:error];
    return MGM_NO_ERROR(error);
}

- (BOOL) rollbackChanges
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    [moc rollback];
    return NO;
}

- (id) threadVersion:(NSManagedObjectID*)moid
{
    if (moid)
    {
        NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
        return [moc objectWithID:moid];
    }
    return nil;
}

@end
