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

- (void) tearDown;

@end

@implementation MGMCoreDataDao (Testing)

@dynamic managedObjectContext;

@end

@interface MGMCoreDataTestCase : SenTestCase

@end

@implementation MGMCoreDataTestCase

static MGMCoreDataDao* cut;

+ (void) setUp
{
    cut = [[MGMCoreDataDao alloc] initWithStoreName:@"MusicGeekMonthyTests.sqlite"];
    // Create the database name and dao
}

+ (void) tearDown
{
    // Delete the database and dao
    NSArray* stores = cut.managedObjectContext.persistentStoreCoordinator.persistentStores;
    NSError* error = nil;
    for (NSPersistentStore* store in stores)
    {
        [cut.managedObjectContext.persistentStoreCoordinator removePersistentStore:store error:&error];
        assert(error == nil);
    }
}

- (void) setUp
{
    [super setUp];
}

- (void) tearDown
{
    [super tearDown];
}

- (void) testCreateSimpleAlbum
{
    NSError* error = nil;
    MGMAlbum* album = [cut fetchAlbum:@"AlbumMbid1" error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNil(album, @"Expecting no albums");

    album = [cut createNewAlbum:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(album, @"Expecting an album");

    album.albumMbid = @"AlbumMbid1";
    album.albumName = @"AlbumName1";
    album.artistName = @"ArtistName1";
    album.score = @6.7;

    album = [cut fetchAlbum:@"AlbumMbid1" error:&error];
    STAssertNil(error, @"Core data error.");
    STAssertNotNil(album, @"Expecting an album");
    STAssertEqualObjects(album.albumMbid, @"AlbumMbid1", @"Expecting data");
    STAssertEqualObjects(album.albumName, @"AlbumName1", @"Expecting data");
    STAssertEqualObjects(album.artistName, @"ArtistName1", @"Expecting data");
    STAssertEquals(album.score.floatValue, (@6.7).floatValue, @"Expecting data");
}

@end
