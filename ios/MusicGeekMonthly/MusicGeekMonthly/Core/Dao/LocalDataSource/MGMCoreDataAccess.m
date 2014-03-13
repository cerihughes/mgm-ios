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
#import "MGMPlaylist.h"
#import "MGMPlaylistItemDto.h"
#import "MGMTimePeriod.h"
#import "MGMTimePeriodDto.h"
#import "MGMWeeklyChart.h"

@interface MGMCoreDataAccess ()

@property (readonly) MGMLocalDataSourceThreadManager* threadManager;

@end

@implementation MGMCoreDataAccess

- (id) init
{
    MGMLocalDataSourceThreadManager* threadManager = [[MGMLocalDataSourceThreadManager alloc] initWithStoreName:@"MusicGeekMonthly1.0.1.sqlite"];
    return [self initWithThreadManager:threadManager];
}

- (id) initWithThreadManager:(MGMLocalDataSourceThreadManager*)threadMananger
{
    if (self = [super init])
    {
        _threadManager = threadMananger;
    }
    return self;
}

- (id) createNewManagedObjectWithName:(NSString*)name
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:moc];
}

typedef BOOL (^PERSIST_BLOCK) (NSError**);
typedef NSManagedObjectID* (^FETCH_BLOCK) (NSError**);
typedef NSArray* (^FETCH_MANY_BLOCK) (NSError**);

- (oneway void) performPersistBlock:(PERSIST_BLOCK)persistBlock completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    [moc performBlock:^{
        NSError* error = nil;
        persistBlock(&error);
        completion(error);
    }];
}

- (oneway void) performFetchBlock:(FETCH_BLOCK)fetchBlock completion:(CORE_DATA_FETCH_COMPLETION)completion
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    [moc performBlock:^{
        NSError* error = nil;
        NSManagedObjectID* moid = fetchBlock(&error);
        completion(moid, error);
    }];
}

- (oneway void) performFetchManyBlock:(FETCH_MANY_BLOCK)fetchManyBlock completion:(CORE_DATA_FETCH_MANY_COMPLETION)completion
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    [moc performBlock:^{
        NSError* error = nil;
        NSArray* moids = fetchManyBlock(&error);
        completion(moids, error);
    }];
}

#pragma mark -
#pragma mark MGMNextUrlAccess

- (oneway void) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    [self performPersistBlock:^BOOL(NSError** error) {
        return [self persistNextUrlAccess:identifier date:date error:error];
    } completion:completion];
}

- (BOOL) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date error:(NSError**)error
{
    NSManagedObjectID* moid = [self fetchNextUrlAccessWithIdentifier:identifier error:error];
    MGMNextUrlAccess* nextUrlAccess = [self mainThreadVersion:moid];
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
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMNextUrlAccess class])];
}

- (oneway void) fetchNextUrlAccessWithIdentifier:(NSString*)identifier completion:(CORE_DATA_FETCH_COMPLETION)completion
{
    [self performFetchBlock:^NSManagedObjectID *(NSError** error) {
        return [self fetchNextUrlAccessWithIdentifier:identifier error:error];
    } completion:completion];
}

- (NSManagedObjectID*) fetchNextUrlAccessWithIdentifier:(NSString*)identifier error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMNextUrlAccess class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMTimePeriod

- (oneway void) persistTimePeriods:(NSArray*)timePeriodDtos completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    [self performPersistBlock:^BOOL(NSError** error) {
        return [self persistTimePeriods:timePeriodDtos error:error];
    } completion:completion];
}

- (BOOL) persistTimePeriods:(NSArray*)timePeriodDtos error:(NSError**)error
{
    for (MGMTimePeriodDto* timePeriodDto in timePeriodDtos)
    {
        NSManagedObjectID* moid = [self fetchTimePeriodWithStartDate:timePeriodDto.startDate endDate:timePeriodDto.endDate error:error];
        MGMTimePeriod* timePeriod = [self mainThreadVersion:moid];
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
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMTimePeriod class])];
}

- (oneway void) fetchAllTimePeriods:(CORE_DATA_FETCH_MANY_COMPLETION)completion
{
    [self performFetchManyBlock:^NSArray *(NSError** error) {
        return [self fetchAllTimePeriodsSync:error];
    } completion:completion];
}

- (NSArray*) fetchAllTimePeriodsSync:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMTimePeriod class]) inManagedObjectContext:moc];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    request.resultType = NSManagedObjectIDResultType;
    return [moc executeFetchRequest:request error:error];
}

- (NSManagedObjectID*) fetchTimePeriodWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMTimePeriod class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMWeeklyChart

- (oneway void) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    [self performPersistBlock:^BOOL(NSError** error) {
        return [self persistWeeklyChart:weeklyChartDto error:error];
    } completion:completion];
}

- (BOOL) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto error:(NSError**)error
{
    NSManagedObjectID* moid = [self fetchWeeklyChartWithStartDate:weeklyChartDto.startDate endDate:weeklyChartDto.endDate error:error];
    MGMWeeklyChart* weeklyChart = [self mainThreadVersion:moid];
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
        NSManagedObjectID* moid = [self fetchChartEntryWithWeeklyChart:weeklyChart rank:chartEntryDto.rank error:error];
        MGMChartEntry* chartEntry = [self mainThreadVersion:moid];
        if (MGM_ERROR(error))
        {
            return [self rollbackChanges];
        }

        if (chartEntry == nil)
        {
            chartEntry = [self createNewChartEntry];
            chartEntry.rank = chartEntryDto.rank;
            chartEntry.weeklyChart = weeklyChart;
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
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMWeeklyChart class])];
}

- (oneway void) fetchWeeklyChartWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(CORE_DATA_FETCH_COMPLETION)completion
{
    [self performFetchBlock:^NSManagedObjectID *(NSError** error) {
        return [self fetchWeeklyChartWithStartDate:startDate endDate:endDate error:error];
    } completion:completion];
}

- (NSManagedObjectID*) fetchWeeklyChartWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMWeeklyChart class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(startDate = %@) AND (endDate = %@)", startDate, endDate];
    request.resultType = NSManagedObjectIDResultType;
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
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMChartEntry class])];
}

- (NSManagedObjectID*) fetchChartEntryWithWeeklyChart:(MGMWeeklyChart*)weeklyChart rank:(NSNumber*)rank error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMChartEntry class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(weeklyChart = %@) AND (rank = %@)", weeklyChart, rank];
    request.resultType = NSManagedObjectIDResultType;
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
    NSManagedObjectID* moid = nil;
    NSString* mbid = albumDto.albumMbid;
    if (mbid && ![mbid hasPrefix:FAKE_MBID_PREPEND])
    {
        moid = [self fetchAlbumWithMbid:albumDto.albumMbid error:error];
    }
    else
    {
        moid = [self fetchAlbumWithArtistName:albumDto.artistName albumName:albumDto.albumName error:error];
    }

    MGMAlbum* album = [self mainThreadVersion:moid];;

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
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMAlbum class])];
}

- (oneway void) fetchAlbumWithMbid:(NSString*)mbid completion:(CORE_DATA_FETCH_COMPLETION)completion
{
    [self performFetchBlock:^NSManagedObjectID *(NSError** error) {
        return [self fetchAlbumWithMbid:mbid error:error];
    } completion:completion];
}

- (NSManagedObjectID*) fetchAlbumWithMbid:(NSString*)mbid error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMAlbum class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"albumMbid = %@", mbid];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (NSManagedObjectID*) fetchAlbumWithArtistName:(NSString*)artistName albumName:(NSString*)albumName error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMAlbum class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(artistName = %@) AND (albumName = %@)", artistName, albumName];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMAlbumImageUri

- (oneway void) addImageUris:(NSArray*)uriDtos toAlbum:(NSManagedObjectID*)albumMoid completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    [self performPersistBlock:^BOOL(NSError** error) {
        return [self addImageUris:uriDtos toAlbum:albumMoid error:error];
    } completion:completion];
}

- (BOOL) addImageUris:(NSArray*)uriDtos toAlbum:(NSManagedObjectID*)albumMoid error:(NSError**)error
{
    MGMAlbum* album = [self mainThreadVersion:albumMoid];
    album.searchedImages = YES;

    if (uriDtos.count > 0)
    {
        [self internal_addImageUris:uriDtos toAlbum:album error:error];
    }

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
        NSManagedObjectID* moid = [self fetchAlbumImageUriWithAlbum:album size:uriDto.size error:error];
        MGMAlbumImageUri* uri = [self mainThreadVersion:moid];
        if (MGM_ERROR(error))
        {
            return;
        }

        if (uri == nil)
        {
            uri = [self createNewAlbumImageUri];
            uri.size = uriDto.size;
            uri.imagedEntity = album;
        }

        uri.uri = uriDto.uri;
    }
}

- (void) internal_addImageUris:(NSArray*)uriDtos toPlaylistItem:(MGMPlaylistItem*)playlistItem error:(NSError**)error
{
    for (MGMAlbumImageUriDto* uriDto in uriDtos)
    {
        MGMAlbumImageUri* uri = [self createNewAlbumImageUri];
        uri.size = uriDto.size;
        uri.uri = uriDto.uri;
        uri.imagedEntity = playlistItem;
    }
}

- (MGMAlbumImageUri*) createNewAlbumImageUri
{
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMAlbumImageUri class])];
}

- (NSManagedObjectID*) fetchAlbumImageUriWithAlbum:(MGMAlbum*)album size:(MGMAlbumImageSize)size error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMAlbumImageUri class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(imagedEntity = %@) AND (sizeObject = %d)", album, size];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMAlbumMetadata

- (oneway void) addMetadata:(MGMAlbumMetadataDto*)metadataDto toAlbum:(NSManagedObjectID*)albumMoid completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    [self performPersistBlock:^BOOL(NSError** error) {
        return [self addMetadata:metadataDto toAlbum:albumMoid error:error];
    } completion:completion];
}

- (BOOL) addMetadata:(MGMAlbumMetadataDto*)metadataDto toAlbum:(NSManagedObjectID*)albumMoid error:(NSError**)error
{
    MGMAlbum* album = [self mainThreadVersion:albumMoid];
    [album setServiceTypeSearched:metadataDto.serviceType];

    if (metadataDto)
    {
        [self internal_addMetadata:@[metadataDto] toAlbum:album error:error];
    }
    
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
        NSManagedObjectID* moid = [self fetchAlbumMetadataWithAlbum:album serviceType:metadataDto.serviceType error:error];
        MGMAlbumMetadata* metadata = [self mainThreadVersion:moid];
        if (MGM_ERROR(error))
        {
            return;
        }

        if (metadata == nil)
        {
            metadata = [self createNewAlbumMetadata];
            metadata.serviceType = metadataDto.serviceType;
            metadata.album = album;
        }

        metadata.value = metadataDto.value;
    }
}

- (MGMAlbumMetadata*) createNewAlbumMetadata
{
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMAlbumMetadata class])];
}

- (NSManagedObjectID*) fetchAlbumMetadataWithAlbum:(MGMAlbum*)album serviceType:(MGMAlbumServiceType)serviceType error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMAlbumMetadata class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(album = %@) AND (serviceTypeObject = %d)", album, serviceType];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMEvent

- (oneway void) persistEvents:(NSArray*)eventDtos completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    [self performPersistBlock:^BOOL(NSError** error) {
        return [self persistEvents:eventDtos error:error];
    } completion:completion];
}

- (BOOL) persistEvents:(NSArray*)eventDtos error:(NSError**)error
{
    for (MGMEventDto* eventDto in eventDtos)
    {
        NSManagedObjectID* moid = [self fetchEventWithEventNumber:eventDto.eventNumber error:error];
        MGMEvent* event = [self mainThreadVersion:moid];
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
        event.playlistId = eventDto.playlistId;

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
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMEvent class])];
}

- (oneway void) fetchAllEvents:(CORE_DATA_FETCH_MANY_COMPLETION)completion
{
    [self performFetchManyBlock:^NSArray *(NSError** error) {
        return [self fetchAllEventsSync:error];
    } completion:completion];
}

- (NSArray*) fetchAllEventsSync:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMEvent class]) inManagedObjectContext:moc];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"eventNumber" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    request.resultType = NSManagedObjectIDResultType;
    return [moc executeFetchRequest:request error:error];
}

- (oneway void) fetchEventWithEventNumber:(NSNumber*)eventNumber completion:(CORE_DATA_FETCH_COMPLETION)completion
{
    [self performFetchBlock:^NSManagedObjectID *(NSError** error) {
        return [self fetchEventWithEventNumber:eventNumber error:error];
    } completion:completion];
}

- (NSManagedObjectID*) fetchEventWithEventNumber:(NSNumber*)eventNumber error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMEvent class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"eventNumber = %@", eventNumber];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (oneway void) fetchAllClassicAlbums:(CORE_DATA_FETCH_MANY_COMPLETION)completion
{
    [self performFetchManyBlock:^NSArray *(NSError** error) {
        return [self fetchAllClassicAlbumsSync:error];
    } completion:completion];
}

- (NSArray*) fetchAllClassicAlbumsSync:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMAlbum class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(classicAlbumEvent != nil) AND (score != nil) AND (score > 0)"];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    request.resultType = NSManagedObjectIDResultType;
    return [moc executeFetchRequest:request error:error];
}

- (oneway void) fetchAllNewlyReleasedAlbums:(CORE_DATA_FETCH_MANY_COMPLETION)completion
{
    [self performFetchManyBlock:^NSArray *(NSError** error) {
        return [self fetchAllNewlyReleasedAlbumsSync:error];
    } completion:completion];
}

- (NSArray*) fetchAllNewlyReleasedAlbumsSync:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMAlbum class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(newlyReleasedAlbumEvent != nil) AND (score != nil) AND (score > 0)"];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    request.resultType = NSManagedObjectIDResultType;
    return [moc executeFetchRequest:request error:error];
}

- (oneway void) fetchAllEventAlbums:(CORE_DATA_FETCH_MANY_COMPLETION)completion
{
    [self performFetchManyBlock:^NSArray *(NSError** error) {
        return [self fetchAllEventAlbumsSync:error];
    } completion:completion];
}

- (NSArray*) fetchAllEventAlbumsSync:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMAlbum class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"((newlyReleasedAlbumEvent != nil) OR (classicAlbumEvent != nil)) AND (score != nil) AND (score > 0)"];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.sortDescriptors = sortDescriptors;
    request.resultType = NSManagedObjectIDResultType;
    return [moc executeFetchRequest:request error:error];
}

#pragma mark -
#pragma mark MGMWeeklyChart

- (oneway void) persistPlaylist:(MGMPlaylistDto*)playlistDto completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    [self performPersistBlock:^BOOL(NSError** error) {
        return [self persistPlaylist:playlistDto error:error];
    } completion:completion];
}

- (BOOL) persistPlaylist:(MGMPlaylistDto*)playlistDto error:(NSError**)error
{
    NSManagedObjectID* moid = [self fetchPlaylistWithId:playlistDto.playlistId error:error];
    MGMPlaylist* playlist = [self mainThreadVersion:moid];
    if (MGM_ERROR(error))
    {
        return [self rollbackChanges];
    }

    if (playlist == nil)
    {
        playlist = [self createNewPlaylist];
        playlist.playlistId = playlistDto.playlistId;
    }

    playlist.name = playlistDto.name;

    // Remove all existing items and re-add the new ones - a merge is pointlessly complex...
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    for (MGMPlaylistItem* playlistItem in playlist.playlistItems)
    {
        [moc deleteObject:playlistItem];
    }

    for (MGMPlaylistItemDto* playlistItemDto in playlistDto.playlistItems)
    {
        MGMPlaylistItem* playlistItem = [self createNewPlaylistItem];
        playlistItem.artist = playlistItemDto.artist;
        playlistItem.album = playlistItemDto.album;
        playlistItem.track = playlistItemDto.track;
        playlistItem.playlist = playlist;

        [self internal_addImageUris:playlistItemDto.imageUris toPlaylistItem:playlistItem error:error];
        if (MGM_ERROR(error))
        {
            return [self rollbackChanges];
        }
    }

    return [self commitChanges:error];
}

- (MGMPlaylist*) createNewPlaylist
{
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMPlaylist class])];
}

- (MGMPlaylistItem*) createNewPlaylistItem
{
    return [self createNewManagedObjectWithName:NSStringFromClass([MGMPlaylistItem class])];
}

- (oneway void) fetchPlaylistWithId:(NSString*)playlistId completion:(CORE_DATA_FETCH_COMPLETION)completion
{
    [self performFetchBlock:^NSManagedObjectID *(NSError** error) {
        return [self fetchPlaylistWithId:playlistId error:error];
    } completion:completion];
}

- (NSManagedObjectID*) fetchPlaylistWithId:(NSString*)playlistId error:(NSError**)error
{
    NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([MGMPlaylist class]) inManagedObjectContext:moc];
    request.predicate = [NSPredicate predicateWithFormat:@"(playlistId = %@)", playlistId];
    request.resultType = NSManagedObjectIDResultType;
    NSArray* results = [moc executeFetchRequest:request error:error];
    if (results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
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

- (id) mainThreadVersion:(NSManagedObjectID*)moid
{
    if ([NSThread isMainThread])
    {
        if (moid)
        {
            NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
            return [moc objectWithID:moid];
        }
        return nil;
    }
    else
    {
        [NSException raise:@"mainThreadVersion must be invoked on main thread." format:@"Invoked on thread %@", [NSThread currentThread]];
        return nil;
    }
}

- (NSArray*) mainThreadVersions:(NSArray*)moids
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:moids.count];
    for (NSManagedObjectID* moid in moids)
    {
        [array addObject:[self mainThreadVersion:moid]];
    }
    return [array copy];
}

@end
