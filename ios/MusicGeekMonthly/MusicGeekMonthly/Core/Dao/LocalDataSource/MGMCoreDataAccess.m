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

#pragma mark -
#pragma mark MGMNextUrlAccess

- (BOOL) persistNextUrlAccess:(NSString*)identifier date:(NSDate *)date error:(NSError**)error
{
    NSManagedObjectID* moid = [self fetchNextUrlAccessWithIdentifier:identifier error:error];
    MGMNextUrlAccess* nextUrlAccess = [self threadVersion:moid];
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

- (BOOL) persistTimePeriods:(NSArray*)timePeriodDtos error:(NSError**)error
{
    for (MGMTimePeriodDto* timePeriodDto in timePeriodDtos)
    {
        NSManagedObjectID* moid = [self fetchTimePeriodWithStartDate:timePeriodDto.startDate endDate:timePeriodDto.endDate error:error];
        MGMTimePeriod* timePeriod = [self threadVersion:moid];
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

- (NSArray*) fetchAllTimePeriods:(NSError**)error
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

- (BOOL) persistWeeklyChart:(MGMWeeklyChartDto*)weeklyChartDto error:(NSError**)error
{
    NSManagedObjectID* moid = [self fetchWeeklyChartWithStartDate:weeklyChartDto.startDate endDate:weeklyChartDto.endDate error:error];
    MGMWeeklyChart* weeklyChart = [self threadVersion:moid];
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
        MGMChartEntry* chartEntry = [self threadVersion:moid];
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

    MGMAlbum* album = [self threadVersion:moid];;

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

- (BOOL) addImageUris:(NSArray*)uriDtos toAlbum:(NSManagedObjectID*)albumMoid error:(NSError**)error
{
    MGMAlbum* album = [self threadVersion:albumMoid];
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
        MGMAlbumImageUri* uri = [self threadVersion:moid];
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

- (BOOL) addMetadata:(MGMAlbumMetadataDto*)metadataDto toAlbum:(NSManagedObjectID*)albumMoid error:(NSError**)error
{
    MGMAlbum* album = [self threadVersion:albumMoid];
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
        MGMAlbumMetadata* metadata = [self threadVersion:moid];
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

- (BOOL) persistEvents:(NSArray*)eventDtos error:(NSError**)error
{
    for (MGMEventDto* eventDto in eventDtos)
    {
        NSManagedObjectID* moid = [self fetchEventWithEventNumber:eventDto.eventNumber error:error];
        MGMEvent* event = [self threadVersion:moid];
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

- (NSArray*) fetchAllEvents:(NSError**)error
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

- (NSArray*) fetchAllClassicAlbums:(NSError**)error
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

- (NSArray*) fetchAllNewlyReleasedAlbums:(NSError**)error
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

- (NSArray*) fetchAllEventAlbums:(NSError**)error
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

- (BOOL) persistPlaylist:(MGMPlaylistDto*)playlistDto error:(NSError**)error
{
    NSManagedObjectID* moid = [self fetchPlaylistWithId:playlistDto.playlistId error:error];
    MGMPlaylist* playlist = [self threadVersion:moid];
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

- (id) threadVersion:(NSManagedObjectID*)moid
{
    if (moid)
    {
        NSManagedObjectContext* moc = [self.threadManager managedObjectContextForCurrentThread];
        return [moc objectWithID:moid];
    }
    return nil;
}

- (NSArray*) threadVersions:(NSArray*)moids
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:moids.count];
    for (NSManagedObjectID* moid in moids)
    {
        [array addObject:[self threadVersion:moid]];
    }
    return [array copy];
}

@end
