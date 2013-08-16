//
//  MGMCoreDataTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "MGMCoreDataDao.h"

@interface MGMCoreDataDao (Testing)

@property (strong) NSManagedObjectContext* managedObjectContext;

- (void) deleteAllObjects:(NSString*)objectType;

@end

@implementation MGMCoreDataDao (Testing)

@dynamic managedObjectContext;

- (void) deleteAllObjects:(NSString*)objectType
{
    NSFetchRequest* fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:objectType inManagedObjectContext:self.managedObjectContext];
    [fetch setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError* error = nil;
    NSArray* allObjects = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    assert(error == nil);
    for (NSManagedObject* object in allObjects)
    {
        [self.managedObjectContext deleteObject:object];
    }

    [self.managedObjectContext save:&error];
    assert(error == nil);
}

@end

@interface MGMCoreDataTestCase : SenTestCase

@property (strong) MGMCoreDataDao* cutInsert;
@property (strong) MGMCoreDataDao* cutFetch;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMCoreDataTestCase

- (void) setUp
{
    [super setUp];
    self.cutInsert = [[MGMCoreDataDao alloc] initWithStoreName:@"MusicGeekMonthyTests.sqlite"];
    self.cutFetch = [[MGMCoreDataDao alloc] initWithStoreName:@"MusicGeekMonthyTests.sqlite"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
}

- (void) tearDown
{
    [self.cutInsert deleteAllObjects:@"MGMTimePeriod"];
    [self.cutInsert deleteAllObjects:@"MGMWeeklyChart"];
    [self.cutInsert deleteAllObjects:@"MGMAlbum"];
    [self.cutInsert deleteAllObjects:@"MGMEvent"];
    [super tearDown];
}

- (void) testCreateTimePeriod
{
    [self.cutInsert deleteAllObjects:@"MGMTimePeriod"];

    NSError* error = nil;
    NSDate* startDate = [self.dateFormatter dateFromString:@"01/01/2001"];
    NSDate* endDate = [self.dateFormatter dateFromString:@"02/02/2002"];

    MGMTimePeriod* object = [self.cutInsert fetchTimePeriod:startDate endDate:endDate error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    object = [self.cutInsert createNewTimePeriod:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");

    object.startDate = startDate;
    object.endDate = endDate;
    
    [self.cutInsert persistChanges:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchTimePeriod:startDate endDate:endDate error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.startDate, startDate, @"Expecting data");
    STAssertEqualObjects(object.endDate, endDate, @"Expecting data");
}

- (void) testCreateWeeklyChartNoEntries
{
    [self.cutInsert deleteAllObjects:@"MGMWeeklyChart"];

    NSError* error = nil;
    NSDate* startDate = [self.dateFormatter dateFromString:@"03/03/2003"];
    NSDate* endDate = [self.dateFormatter dateFromString:@"04/04/2004"];

    MGMWeeklyChart* object = [self.cutInsert fetchWeeklyChart:startDate endDate:endDate error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    object = [self.cutInsert createNewWeeklyChart:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");

    object.startDate = startDate;
    object.endDate = endDate;

    [self.cutInsert persistChanges:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchWeeklyChart:startDate endDate:endDate error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.startDate, startDate, @"Expecting data");
    STAssertEqualObjects(object.endDate, endDate, @"Expecting data");
}

- (void) testCreateEventNoAlbums
{
    [self.cutInsert deleteAllObjects:@"MGMEvent"];

    NSError* error = nil;
    NSDate* eventDate = [self.dateFormatter dateFromString:@"05/05/2005"];

    MGMEvent* object = [self.cutInsert fetchEvent:@1 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    object = [self.cutInsert createNewEvent:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");

    object.eventNumber = @1;
    object.eventDate = eventDate;
    object.spotifyPlaylistId = @"playlistId";

    [self.cutInsert persistChanges:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchEvent:@1 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.eventNumber, @1, @"Expecting data");
    STAssertEqualObjects(object.eventDate, eventDate, @"Expecting data");
    STAssertEqualObjects(object.spotifyPlaylistId, @"playlistId", @"Expecting data");
}

- (void) testCreateEventWithSimpleAlbums
{
    [self.cutInsert deleteAllObjects:@"MGMAlbum"];
    [self.cutInsert deleteAllObjects:@"MGMEvent"];

    NSError* error = nil;
    NSDate* eventDate = [self.dateFormatter dateFromString:@"06/06/2006"];

    MGMEvent* object = [self.cutInsert fetchEvent:@2 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    object = [self.cutInsert createNewEvent:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");

    STAssertNil([self.cutInsert fetchAlbum:@"Event2AlbumMbid1" error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    object.classicAlbum = [self.cutInsert createNewAlbum:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object.classicAlbum, @"Expecting an object");

    object.classicAlbum.albumMbid = @"Event2AlbumMbid1";
    object.classicAlbum.albumName = @"Event2AlbumName1";
    object.classicAlbum.artistName = @"Event2ArtistName1";
    object.classicAlbum.score = @1.2;
    
    STAssertNil([self.cutInsert fetchAlbum:@"Event2AlbumMbid2" error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    object.newlyReleasedAlbum = [self.cutInsert createNewAlbum:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object.newlyReleasedAlbum, @"Expecting an object");

    object.newlyReleasedAlbum.albumMbid = @"Event2AlbumMbid2";
    object.newlyReleasedAlbum.albumName = @"Event2AlbumName2";
    object.newlyReleasedAlbum.artistName = @"Event2ArtistName2";
    object.newlyReleasedAlbum.score = @3.4;
    
    object.eventNumber = @2;
    object.eventDate = eventDate;
    object.spotifyPlaylistId = @"playlistId";

    [self.cutInsert persistChanges:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchEvent:@2 error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.eventNumber, @2, @"Expecting data");
    STAssertEqualObjects(object.eventDate, eventDate, @"Expecting data");
    STAssertEqualObjects(object.spotifyPlaylistId, @"playlistId", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.albumMbid, @"Event2AlbumMbid1", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.albumName, @"Event2AlbumName1", @"Expecting data");
    STAssertEqualObjects(object.classicAlbum.artistName, @"Event2ArtistName1", @"Expecting data");
    STAssertEquals(object.classicAlbum.score.floatValue, (@1.2).floatValue, @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.albumMbid, @"Event2AlbumMbid2", @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.albumName, @"Event2AlbumName2", @"Expecting data");
    STAssertEqualObjects(object.newlyReleasedAlbum.artistName, @"Event2ArtistName2", @"Expecting data");
    STAssertEquals(object.newlyReleasedAlbum.score.floatValue, (@3.4).floatValue, @"Expecting data");
}

- (void) testCreateSimpleAlbum
{
    [self.cutInsert deleteAllObjects:@"MGMAlbum"];

    NSError* error = nil;
    MGMAlbum* object = [self.cutInsert fetchAlbum:@"AlbumMbid" error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    object = [self.cutInsert createNewAlbum:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");

    object.albumMbid = @"AlbumMbid";
    object.albumName = @"AlbumName";
    object.artistName = @"ArtistName";
    object.score = @6.7;

    [self.cutInsert persistChanges:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchAlbum:@"AlbumMbid" error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.albumMbid, @"AlbumMbid", @"Expecting data");
    STAssertEqualObjects(object.albumName, @"AlbumName", @"Expecting data");
    STAssertEqualObjects(object.artistName, @"ArtistName", @"Expecting data");
    STAssertEquals(object.score.floatValue, (@6.7).floatValue, @"Expecting data");
}

- (void) testCreateComplexAlbum
{
    [self.cutInsert deleteAllObjects:@"MGMAlbum"];

    NSError* error = nil;
    MGMAlbum* object = [self.cutInsert fetchAlbum:@"AlbumMbid" error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(object, @"Expecting no object");

    object = [self.cutInsert createNewAlbum:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");

    object.albumMbid = @"AlbumMbid";
    object.albumName = @"AlbumName";
    object.artistName = @"ArtistName";
    object.score = @6.7;

    STAssertEquals(object.imageUris.count, (NSUInteger)0, @"Expecting no data");
    STAssertEquals(object.metadata.count, (NSUInteger)0, @"Expecting no data");

    STAssertNil([self.cutInsert fetchAlbumImageUriForAlbum:object size:MGMAlbumImageSizeSmall error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    STAssertNil([self.cutInsert fetchAlbumImageUriForAlbum:object size:MGMAlbumImageSizeMedium error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    STAssertNil([self.cutInsert fetchAlbumMetadataForAlbum:object serviceType:MGMAlbumServiceTypeSpotify error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    STAssertNil([self.cutInsert fetchAlbumMetadataForAlbum:object serviceType:MGMAlbumServiceTypeLastFm error:&error], @"Expecting no object");
    STAssertNil(error, @"Core data error.");

    MGMAlbumImageUri* uri = [self.cutInsert createNewAlbumImageUri:&error];
    STAssertNotNil(uri, @"Expecting an object");
    STAssertNil(error, @"Core data error.");
    uri.size = MGMAlbumImageSizeSmall;
    uri.uri = @"smallUri";
    [object addImageUrisObject:uri];

    uri = [self.cutInsert createNewAlbumImageUri:&error];
    STAssertNotNil(uri, @"Expecting an object");
    STAssertNil(error, @"Core data error.");
    uri.size = MGMAlbumImageSizeMedium;
    uri.uri = @"mediumUri";
    [object addImageUrisObject:uri];

    MGMAlbumMetadata* metadata = [self.cutInsert createNewAlbumMetadata:&error];
    STAssertNotNil(metadata, @"Expecting an object");
    STAssertNil(error, @"Core data error.");
    metadata.serviceType = MGMAlbumServiceTypeSpotify;
    metadata.value = @"spotifyServiceType";
    [object addMetadataObject:metadata];

    metadata = [self.cutInsert createNewAlbumMetadata:&error];
    STAssertNotNil(metadata, @"Expecting an object");
    STAssertNil(error, @"Core data error.");
    metadata.serviceType = MGMAlbumServiceTypeLastFm;
    metadata.value = @"lastfmServiceType";
    [object addMetadataObject:metadata];

    STAssertEquals(object.imageUris.count, (NSUInteger)2, @"Expecting data");
    STAssertEquals(object.metadata.count, (NSUInteger)2, @"Expecting data");

    [self.cutInsert persistChanges:&error];
    STAssertNil(error, @"Core data error.");

    object = [self.cutFetch fetchAlbum:@"AlbumMbid" error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(object, @"Expecting an object");
    STAssertEqualObjects(object.albumMbid, @"AlbumMbid", @"Expecting data");
    STAssertEqualObjects(object.albumName, @"AlbumName", @"Expecting data");
    STAssertEqualObjects(object.artistName, @"ArtistName", @"Expecting data");
    STAssertEquals(object.score.floatValue, (@6.7).floatValue, @"Expecting data");
    STAssertEquals(object.imageUris.count, (NSUInteger)2, @"Expecting data");
    STAssertEquals(object.metadata.count, (NSUInteger)2, @"Expecting data");
}

@end
