//
//  MGMCoreDataTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "MGMAlbumImageUriDto.h"
#import "MGMAlbumMetadataDto.h"
#import "MGMCoreDataAccess.h"
#import "MGMEventDto.h"
#import "MGMTimePeriod.h"
#import "MGMTimePeriodDto.h"
#import "MGMWeeklyChart.h"
#import "MGMWeeklyChartDto.h"

@interface MGMCoreDataAccess (Testing)

@property (readonly) NSManagedObjectContext* masterMoc;

- (id) initWithStoreName:(NSString*)storeName;

@end

@interface MGMCoreDataTestCase : SenTestCase

@property (strong) MGMCoreDataAccess* cutInsert;
@property (strong) MGMCoreDataAccess* cutFetch;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMCoreDataTestCase

#define TEST_STORE_NAME @"MusicGeekMonthyTests.sqlite"

- (void) setUp
{
    [super setUp];
    self.cutInsert = [[MGMCoreDataAccess alloc] initWithStoreName:TEST_STORE_NAME];
    self.cutFetch = [[MGMCoreDataAccess alloc] initWithStoreName:TEST_STORE_NAME];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
}

- (void) tearDown
{
    [self deleteAllObjects:@"MGMTimePeriod"];
    [self deleteAllObjects:@"MGMWeeklyChart"];
    [self deleteAllObjects:@"MGMAlbum"];
    [self deleteAllObjects:@"MGMEvent"];
    [super tearDown];
}

- (void) deleteAllObjects:(NSString*)objectType
{
    NSManagedObjectContext* managedObjectContext = self.cutFetch.masterMoc;
    NSFetchRequest* fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:objectType inManagedObjectContext:managedObjectContext];
    [fetch setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError* error = nil;
    NSArray* allObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    assert(error == nil);
    for (NSManagedObject* object in allObjects)
    {
        [managedObjectContext deleteObject:object];
    }

    [managedObjectContext save:&error];
    assert(error == nil);
}

- (void) testCreateTimePeriod
{
    [self deleteAllObjects:@"MGMTimePeriod"];

    NSDate* startDate = [self.dateFormatter dateFromString:@"01/01/2001"];
    NSDate* endDate = [self.dateFormatter dateFromString:@"02/02/2002"];

    [self.cutInsert fetchAllTimePeriods:^(NSArray* objects, NSError* fetchError) {
        STAssertNil(fetchError, @"Core data error.");
        STAssertEquals(objects.count, (NSUInteger)0, @"Expecting no object");
        
        MGMTimePeriodDto* timePeriodDto = [[MGMTimePeriodDto alloc] init];
        timePeriodDto.startDate = startDate;
        timePeriodDto.endDate = endDate;
        
        [self.cutInsert persistTimePeriods:[NSArray arrayWithObject:timePeriodDto] completion:^(NSError* persistError) {
            STAssertNil(persistError, @"Core data error.");
            
            [self.cutFetch fetchAllTimePeriods:^(NSArray* objects2, NSError* fetchError2) {
                STAssertNil(fetchError2, @"Core data error.");
                STAssertEquals(objects2.count, (NSUInteger)1, @"Expecting an object");
                
                MGMTimePeriod* timePeriod = [objects2 objectAtIndex:0];
                STAssertNotNil(timePeriod, @"Expecting an object");
                STAssertEqualObjects(timePeriod.startDate, startDate, @"Expecting data");
                STAssertEqualObjects(timePeriod.endDate, endDate, @"Expecting data");
            }];
        }];
    }];
}

- (void) testCreateWeeklyChartNoEntries
{
    [self deleteAllObjects:@"MGMWeeklyChart"];

    NSDate* startDate = [self.dateFormatter dateFromString:@"03/03/2003"];
    NSDate* endDate = [self.dateFormatter dateFromString:@"04/04/2004"];

    [self.cutInsert fetchWeeklyChartWithStartDate:startDate endDate:endDate completion:^(NSManagedObjectID* moid, NSError* fetchError) {
        STAssertNil(fetchError, @"Core data error.");
        STAssertNil(moid, @"Expecting no object");
        
        MGMWeeklyChartDto* weeklyChartDto = [[MGMWeeklyChartDto alloc] init];
        weeklyChartDto.startDate = startDate;
        weeklyChartDto.endDate = endDate;
        
        [self.cutInsert persistWeeklyChart:weeklyChartDto completion:^(NSError* persistError) {
            STAssertNil(persistError, @"Core data error.");
            
            [self.cutFetch fetchWeeklyChartWithStartDate:startDate endDate:endDate completion:^(NSManagedObjectID* moid2, NSError* fetchError2) {
                STAssertNil(fetchError2, @"Core data error.");
                
                MGMWeeklyChart* weeklyChart = [self.cutFetch mainThreadVersion:moid2];
                STAssertNotNil(weeklyChart, @"Expecting an object");
                STAssertEqualObjects(weeklyChart.startDate, startDate, @"Expecting data");
                STAssertEqualObjects(weeklyChart.endDate, endDate, @"Expecting data");
            }];
        }];
    }];
}

- (void) testCreateEventNoAlbums
{
    [self deleteAllObjects:@"MGMEvent"];

    NSDate* eventDate = [self.dateFormatter dateFromString:@"05/05/2005"];

    [self.cutInsert fetchEventWithEventNumber:@1 completion:^(NSManagedObjectID* moid, NSError* fetchError) {
        STAssertNil(fetchError, @"Core data error.");
        STAssertNil(moid, @"Expecting no object");
        
        MGMEventDto* eventDto = [[MGMEventDto alloc] init];
        eventDto.eventNumber = @1;
        eventDto.eventDate = eventDate;
        eventDto.playlistId = @"playlistId";

        [self.cutInsert persistEvents:[NSArray arrayWithObject:eventDto] completion:^(NSError* persistError) {
            STAssertNil(persistError, @"Core data error.");
            
            [self.cutFetch fetchEventWithEventNumber:@1 completion:^(NSManagedObjectID* moid2, NSError* fetchError2) {
                STAssertNil(fetchError2, @"Core data error.");

                MGMEvent* event = [self.cutFetch mainThreadVersion:moid2];
                STAssertNotNil(event, @"Expecting an object");
                STAssertEqualObjects(event.eventNumber, @1, @"Expecting data");
                STAssertEqualObjects(event.eventDate, eventDate, @"Expecting data");
                STAssertEqualObjects(event.playlistId, @"playlistId", @"Expecting data");
            }];
        }];
    }];
}

- (MGMEventDto*) simpleAlbumsEventWithDate:(NSDate*)eventDate
{
    MGMEventDto* eventDto = [[MGMEventDto alloc] init];
    eventDto.eventNumber = @2;
    eventDto.eventDate = eventDate;
    eventDto.playlistId = @"playlistId";

    MGMAlbumDto* classicAlbumDto = [[MGMAlbumDto alloc] init];
    classicAlbumDto.albumMbid = @"Event2AlbumMbid1";
    classicAlbumDto.albumName = @"Event2AlbumName1";
    classicAlbumDto.artistName = @"Event2ArtistName1";
    classicAlbumDto.score = @1.2;

    MGMAlbumDto* newlyReleasedAlbumDto = [[MGMAlbumDto alloc] init];
    newlyReleasedAlbumDto.albumMbid = @"Event2AlbumMbid2";
    newlyReleasedAlbumDto.albumName = @"Event2AlbumName2";
    newlyReleasedAlbumDto.artistName = @"Event2ArtistName2";
    newlyReleasedAlbumDto.score = @3.4;

    eventDto.classicAlbum = classicAlbumDto;
    eventDto.newlyReleasedAlbum = newlyReleasedAlbumDto;

    return eventDto;
}

- (void) testCreateEventWithSimpleAlbums
{
    [self deleteAllObjects:@"MGMAlbum"];
    [self deleteAllObjects:@"MGMEvent"];

    NSDate* eventDate = [self.dateFormatter dateFromString:@"06/06/2006"];

    [self.cutInsert fetchEventWithEventNumber:@2 completion:^(NSManagedObjectID* eventMoid, NSError* eventFetchError) {
        STAssertNil(eventFetchError, @"Core data error.");
        STAssertNil(eventMoid, @"Expecting no object");
        
        [self.cutInsert fetchAlbumWithMbid:@"Event2AlbumMbid1" completion:^(NSManagedObjectID* albumMoid, NSError* albumFetchError) {
            STAssertNil(albumMoid, @"Expecting no object");
            STAssertNil(albumFetchError, @"Core data error.");
            
            [self.cutInsert fetchAlbumWithMbid:@"Event2AlbumMbid2" completion:^(NSManagedObjectID* albumMoid2, NSError* albumFetchError2) {
                STAssertNil(albumMoid2, @"Expecting no object");
                STAssertNil(albumFetchError2, @"Core data error.");

                MGMEventDto* eventDto = [self simpleAlbumsEventWithDate:eventDate];

                [self.cutInsert persistEvents:[NSArray arrayWithObject:eventDto] completion:^(NSError* persistError) {
                    STAssertNil(persistError, @"Core data error.");
                    
                    [self.cutFetch fetchEventWithEventNumber:@2 completion:^(NSManagedObjectID* eventMoid2, NSError* eventFetchError2) {
                        STAssertNil(eventFetchError2, @"Core data error.");

                        MGMEvent* event = [self.cutFetch mainThreadVersion:eventMoid2];
                        STAssertNotNil(event, @"Expecting an object");
                        STAssertEqualObjects(event.eventNumber, @2, @"Expecting data");
                        STAssertEqualObjects(event.eventDate, eventDate, @"Expecting data");
                        STAssertEqualObjects(event.playlistId, @"playlistId", @"Expecting data");
                        STAssertEqualObjects(event.classicAlbum.albumMbid, @"Event2AlbumMbid1", @"Expecting data");
                        STAssertEqualObjects(event.classicAlbum.albumName, @"Event2AlbumName1", @"Expecting data");
                        STAssertEqualObjects(event.classicAlbum.artistName, @"Event2ArtistName1", @"Expecting data");
                        STAssertEquals(event.classicAlbum.score.floatValue, (@1.2).floatValue, @"Expecting data");
                        STAssertEqualObjects(event.newlyReleasedAlbum.albumMbid, @"Event2AlbumMbid2", @"Expecting data");
                        STAssertEqualObjects(event.newlyReleasedAlbum.albumName, @"Event2AlbumName2", @"Expecting data");
                        STAssertEqualObjects(event.newlyReleasedAlbum.artistName, @"Event2ArtistName2", @"Expecting data");
                        STAssertEquals(event.newlyReleasedAlbum.score.floatValue, (@3.4).floatValue, @"Expecting data");
                    }];
                }];
            }];
        }];
    }];
}

- (MGMEventDto*) complexAlbumsEventWithDate:(NSDate*)eventDate
{
    MGMEventDto* eventDto = [[MGMEventDto alloc] init];
    eventDto.eventNumber = @3;
    eventDto.eventDate = eventDate;
    eventDto.playlistId = @"playlistId";

    MGMAlbumDto* classicAlbumDto = [[MGMAlbumDto alloc] init];
    classicAlbumDto.albumMbid = @"Event3AlbumMbid1";
    classicAlbumDto.albumName = @"Event3AlbumName1";
    classicAlbumDto.artistName = @"Event3ArtistName1";
    classicAlbumDto.score = @5.6;

    MGMAlbumDto* newlyReleasedAlbumDto = [[MGMAlbumDto alloc] init];
    newlyReleasedAlbumDto.albumMbid = @"Event3AlbumMbid2";
    newlyReleasedAlbumDto.albumName = @"Event3AlbumName2";
    newlyReleasedAlbumDto.artistName = @"Event3ArtistName2";
    newlyReleasedAlbumDto.score = @7.8;

    MGMAlbumImageUriDto* uri = [[MGMAlbumImageUriDto alloc] init];
    uri.size = MGMAlbumImageSize32;
    uri.uri = @"smallUri";
    [classicAlbumDto.imageUris addObject:uri];

    uri = [[MGMAlbumImageUriDto alloc] init];
    uri.size = MGMAlbumImageSize64;
    uri.uri = @"mediumUri";
    [classicAlbumDto.imageUris addObject:uri];

    MGMAlbumMetadataDto* metadata = [[MGMAlbumMetadataDto alloc] init];
    metadata.serviceType = MGMAlbumServiceTypeSpotify;
    metadata.value = @"spotifyServiceType";
    [classicAlbumDto.metadata addObject:metadata];

    metadata = [[MGMAlbumMetadataDto alloc] init];
    metadata.serviceType = MGMAlbumServiceTypeLastFm;
    metadata.value = @"lastfmServiceType";
    [classicAlbumDto.metadata addObject:metadata];

    uri = [[MGMAlbumImageUriDto alloc] init];
    uri.size = MGMAlbumImageSize128;
    uri.uri = @"largeUri";
    [newlyReleasedAlbumDto.imageUris addObject:uri];

    uri = [[MGMAlbumImageUriDto alloc] init];
    uri.size = MGMAlbumImageSize256;
    uri.uri = @"extraLargeUri";
    [newlyReleasedAlbumDto.imageUris addObject:uri];

    metadata = [[MGMAlbumMetadataDto alloc] init];
    metadata.serviceType = MGMAlbumServiceTypeWikipedia;
    metadata.value = @"wikipediaServiceType";
    [newlyReleasedAlbumDto.metadata addObject:metadata];

    metadata = [[MGMAlbumMetadataDto alloc] init];
    metadata.serviceType = MGMAlbumServiceTypeYouTube;
    metadata.value = @"youTubeServiceType";
    [newlyReleasedAlbumDto.metadata addObject:metadata];

    eventDto.classicAlbum = classicAlbumDto;
    eventDto.newlyReleasedAlbum = newlyReleasedAlbumDto;

    return eventDto;
}

- (void) testCreateEventWithComplexAlbums
{
    [self deleteAllObjects:@"MGMAlbum"];
    [self deleteAllObjects:@"MGMEvent"];

    NSDate* eventDate = [self.dateFormatter dateFromString:@"07/07/2007"];

    [self.cutInsert fetchEventWithEventNumber:@3 completion:^(NSManagedObjectID* eventMoid, NSError* eventFetchError) {
        STAssertNil(eventFetchError, @"Core data error.");
        STAssertNil(eventMoid, @"Expecting no object");

        [self.cutInsert fetchAlbumWithMbid:@"Event3AlbumMbid1" completion:^(NSManagedObjectID* albumMoid, NSError* albumFetchError) {
            STAssertNil(albumMoid, @"Expecting no object");
            STAssertNil(albumFetchError, @"Core data error.");

            [self.cutInsert fetchAlbumWithMbid:@"Event3AlbumMbid2" completion:^(NSManagedObjectID* albumMoid2, NSError* albumFetchError2) {
                STAssertNil(albumMoid2, @"Expecting no object");
                STAssertNil(albumFetchError2, @"Core data error.");

                MGMEventDto* eventDto = [self complexAlbumsEventWithDate:eventDate];

                [self.cutInsert persistEvents:[NSArray arrayWithObject:eventDto] completion:^(NSError* persistError) {
                    STAssertNil(persistError, @"Core data error.");

                    [self.cutFetch fetchEventWithEventNumber:@3 completion:^(NSManagedObjectID* eventMoid2, NSError* eventFetchError2) {
                        STAssertNil(eventFetchError2, @"Core data error.");

                        MGMEvent* event = [self.cutFetch mainThreadVersion:eventMoid2];
                        STAssertNotNil(event, @"Expecting an object");
                        STAssertEqualObjects(event.eventNumber, @3, @"Expecting data");
                        STAssertEqualObjects(event.eventDate, eventDate, @"Expecting data");
                        STAssertEqualObjects(event.playlistId, @"playlistId", @"Expecting data");
                        STAssertEqualObjects(event.classicAlbum.albumMbid, @"Event3AlbumMbid1", @"Expecting data");
                        STAssertEqualObjects(event.classicAlbum.albumName, @"Event3AlbumName1", @"Expecting data");
                        STAssertEqualObjects(event.classicAlbum.artistName, @"Event3ArtistName1", @"Expecting data");
                        STAssertEquals(event.classicAlbum.score.floatValue, (@5.6).floatValue, @"Expecting data");
                        STAssertEquals(event.classicAlbum.imageUris.count, (NSUInteger)2, @"Expecting data");
                        STAssertEquals(event.classicAlbum.metadata.count, (NSUInteger)2, @"Expecting data");

                        STAssertEqualObjects(event.newlyReleasedAlbum.albumMbid, @"Event3AlbumMbid2", @"Expecting data");
                        STAssertEqualObjects(event.newlyReleasedAlbum.albumName, @"Event3AlbumName2", @"Expecting data");
                        STAssertEqualObjects(event.newlyReleasedAlbum.artistName, @"Event3ArtistName2", @"Expecting data");
                        STAssertEquals(event.newlyReleasedAlbum.score.floatValue, (@7.8).floatValue, @"Expecting data");
                        STAssertEquals(event.newlyReleasedAlbum.imageUris.count, (NSUInteger)2, @"Expecting data");
                        STAssertEquals(event.newlyReleasedAlbum.metadata.count, (NSUInteger)2, @"Expecting data");
                    }];
                }];
            }];
        }];
    }];
}

@end
