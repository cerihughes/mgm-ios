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
#import "MGMLocalDataSourceThreadManager.h"
#import "MGMTimePeriod.h"
#import "MGMTimePeriodDto.h"
#import "MGMWeeklyChartDto.h"

@interface MGMCoreDataAccess (Testing)

- (id) initWithThreadManager:(MGMLocalDataSourceThreadManager*)threadMananger;

@end

@interface MGMCoreDataTestCase : SenTestCase

@property (strong) MGMCoreDataAccess* cutInsert;
@property (strong) MGMCoreDataAccess* cutFetch;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMCoreDataTestCase

#define TEST_STORE_NAME @"MusicGeekMonthyTests.sqlite"

static MGMLocalDataSourceThreadManager* _threadManager;

+ (void) setUp
{
    _threadManager = [[MGMLocalDataSourceThreadManager alloc] initWithStoreName:TEST_STORE_NAME];
}

+ (void) tearDown
{
    _threadManager = nil;
}

- (void) setUp
{
    [super setUp];
    self.cutInsert = [[MGMCoreDataAccess alloc] initWithThreadManager:_threadManager];
    self.cutFetch = [[MGMCoreDataAccess alloc] initWithThreadManager:_threadManager];
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
    NSManagedObjectContext* managedObjectContext = [_threadManager managedObjectContextForCurrentThread];
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

    NSError* error = nil;
    NSDate* startDate = [self.dateFormatter dateFromString:@"01/01/2001"];
    NSDate* endDate = [self.dateFormatter dateFromString:@"02/02/2002"];

    NSArray* objects = [self.cutInsert fetchAllTimePeriods:&error];
    STAssertNil(error, @"Core data error.");
    STAssertEquals(objects.count, (NSUInteger)0, @"Expecting no object");

    MGMTimePeriodDto* timePeriodDto = [[MGMTimePeriodDto alloc] init];
    timePeriodDto.startDate = startDate;
    timePeriodDto.endDate = endDate;

    [self.cutInsert persistTimePeriods:[NSArray arrayWithObject:timePeriodDto] error:&error];
    STAssertNil(error, @"Core data error.");

    objects = [self.cutFetch fetchAllTimePeriods:&error];
    STAssertNil(error, @"Core data error.");
    STAssertEquals(objects.count, (NSUInteger)1, @"Expecting an object");

    MGMTimePeriod* timePeriod = [objects objectAtIndex:0];
    STAssertNotNil(timePeriod, @"Expecting an object");
    STAssertEqualObjects(timePeriod.startDate, startDate, @"Expecting data");
    STAssertEqualObjects(timePeriod.endDate, endDate, @"Expecting data");
}

- (void) testCreateWeeklyChartNoEntries
{
    [self deleteAllObjects:@"MGMWeeklyChart"];

    NSError* error = nil;
    NSDate* startDate = [self.dateFormatter dateFromString:@"03/03/2003"];
    NSDate* endDate = [self.dateFormatter dateFromString:@"04/04/2004"];

    MGMWeeklyChart* object = [self.cutInsert fetchWeeklyChartWithStartDate:startDate endDate:endDate error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    MGMWeeklyChartDto* weeklyChartDto = [[MGMWeeklyChartDto alloc] init];
    weeklyChartDto.startDate = startDate;
    weeklyChartDto.endDate = endDate;

    [self.cutInsert persistWeeklyChart:weeklyChartDto error:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchWeeklyChartWithStartDate:startDate endDate:endDate error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.startDate, startDate, @"Expecting data");
    STAssertEqualObjects(object.endDate, endDate, @"Expecting data");
}

- (void) testCreateEventNoAlbums
{
    [self deleteAllObjects:@"MGMEvent"];

    NSError* error = nil;
    NSDate* eventDate = [self.dateFormatter dateFromString:@"05/05/2005"];

    MGMEvent* object = [self.cutInsert fetchEventWithEventNumber:@1 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    MGMEventDto* eventDto = [[MGMEventDto alloc] init];
    eventDto.eventNumber = @1;
    eventDto.eventDate = eventDate;
    eventDto.playlistId = @"playlistId";

    object.eventNumber = @1;
    object.eventDate = eventDate;
    object.playlistId = @"playlistId";

    [self.cutInsert persistEvents:[NSArray arrayWithObject:eventDto] error:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchEventWithEventNumber:@1 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.eventNumber, @1, @"Expecting data");
    STAssertEqualObjects(object.eventDate, eventDate, @"Expecting data");
    STAssertEqualObjects(object.playlistId, @"playlistId", @"Expecting data");
}

- (void) testCreateEventWithSimpleAlbums
{
    [self deleteAllObjects:@"MGMAlbum"];
    [self deleteAllObjects:@"MGMEvent"];

    NSError* error = nil;
    NSDate* eventDate = [self.dateFormatter dateFromString:@"06/06/2006"];

    MGMEvent* object = [self.cutInsert fetchEventWithEventNumber:@2 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    MGMEventDto* eventDto = [[MGMEventDto alloc] init];
    eventDto.eventNumber = @2;
    eventDto.eventDate = eventDate;
    eventDto.playlistId = @"playlistId";

    STAssertNil([self.cutInsert fetchAlbumWithMbid:@"Event2AlbumMbid1" error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    MGMAlbumDto* classicAlbumDto = [[MGMAlbumDto alloc] init];
    classicAlbumDto.albumMbid = @"Event2AlbumMbid1";
    classicAlbumDto.albumName = @"Event2AlbumName1";
    classicAlbumDto.artistName = @"Event2ArtistName1";
    classicAlbumDto.score = @1.2;
    
    STAssertNil([self.cutInsert fetchAlbumWithMbid:@"Event2AlbumMbid2" error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    MGMAlbumDto* newlyReleasedAlbumDto = [[MGMAlbumDto alloc] init];
    newlyReleasedAlbumDto.albumMbid = @"Event2AlbumMbid2";
    newlyReleasedAlbumDto.albumName = @"Event2AlbumName2";
    newlyReleasedAlbumDto.artistName = @"Event2ArtistName2";
    newlyReleasedAlbumDto.score = @3.4;

    eventDto.classicAlbum = classicAlbumDto;
    eventDto.newlyReleasedAlbum = newlyReleasedAlbumDto;
    
    [self.cutInsert persistEvents:[NSArray arrayWithObject:eventDto] error:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchEventWithEventNumber:@2 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.eventNumber, @2, @"Expecting data");
    STAssertEqualObjects(object.eventDate, eventDate, @"Expecting data");
    STAssertEqualObjects(object.playlistId, @"playlistId", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.albumMbid, @"Event2AlbumMbid1", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.albumName, @"Event2AlbumName1", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.artistName, @"Event2ArtistName1", @"Expecting data");
    STAssertEquals(object.classicAlbum.score.floatValue, (@1.2).floatValue, @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.albumMbid, @"Event2AlbumMbid2", @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.albumName, @"Event2AlbumName2", @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.artistName, @"Event2ArtistName2", @"Expecting data");
    STAssertEquals(object.newlyReleasedAlbum.score.floatValue, (@3.4).floatValue, @"Expecting data");
}

- (void) testCreateEventWithComplexAlbums
{
    [self deleteAllObjects:@"MGMAlbum"];
    [self deleteAllObjects:@"MGMEvent"];

    NSError* error = nil;
    NSDate* eventDate = [self.dateFormatter dateFromString:@"07/07/2007"];

    MGMEvent* object = [self.cutInsert fetchEventWithEventNumber:@3 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    MGMEventDto* eventDto = [[MGMEventDto alloc] init];
    eventDto.eventNumber = @3;
    eventDto.eventDate = eventDate;
    eventDto.playlistId = @"playlistId";

    STAssertNil([self.cutInsert fetchAlbumWithMbid:@"Event3AlbumMbid1" error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    MGMAlbumDto* classicAlbumDto = [[MGMAlbumDto alloc] init];
    classicAlbumDto.albumMbid = @"Event3AlbumMbid1";
    classicAlbumDto.albumName = @"Event3AlbumName1";
    classicAlbumDto.artistName = @"Event3ArtistName1";
    classicAlbumDto.score = @5.6;

    STAssertNil([self.cutInsert fetchAlbumWithMbid:@"Event3AlbumMbid2" error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

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

    [self.cutInsert persistEvents:[NSArray arrayWithObject:eventDto] error:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchEventWithEventNumber:@3 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.eventNumber, @3, @"Expecting data");
    STAssertEqualObjects(object.eventDate, eventDate, @"Expecting data");
    STAssertEqualObjects(object.playlistId, @"playlistId", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.albumMbid, @"Event3AlbumMbid1", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.albumName, @"Event3AlbumName1", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.artistName, @"Event3ArtistName1", @"Expecting data");
    STAssertEquals(object.classicAlbum.score.floatValue, (@5.6).floatValue, @"Expecting data");
    STAssertEquals(object.classicAlbum.imageUris.count, (NSUInteger)2, @"Expecting data");
    STAssertEquals(object.classicAlbum.metadata.count, (NSUInteger)2, @"Expecting data");

    STAssertEqualObjects(object.newlyReleasedAlbum.albumMbid, @"Event3AlbumMbid2", @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.albumName, @"Event3AlbumName2", @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.artistName, @"Event3ArtistName2", @"Expecting data");
    STAssertEquals(object.newlyReleasedAlbum.score.floatValue, (@7.8).floatValue, @"Expecting data");
    STAssertEquals(object.newlyReleasedAlbum.imageUris.count, (NSUInteger)2, @"Expecting data");
    STAssertEquals(object.newlyReleasedAlbum.metadata.count, (NSUInteger)2, @"Expecting data");
}

@end
