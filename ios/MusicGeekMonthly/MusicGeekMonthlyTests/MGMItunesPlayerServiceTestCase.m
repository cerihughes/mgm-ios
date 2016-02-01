//
//  MGMItunesPlayerServiceTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/04/15.
//  Copyright (c) 2015 Ceri Hughes. All rights reserved.
//

#import "MGMTestCase.h"

#import "MGMItunesPlayerService.h"
#import "MGMRemoteJsonDataConverter.h"

#import <OCMockito/OCMockito.h>

@interface MGMItunesPlayerServiceTestCase : MGMTestCase

@property (nonatomic, strong) MGMItunesPlayerService *cut;
@property (nonatomic, strong) MGMRemoteJsonDataConverter *dataConverter;

@end

@implementation MGMItunesPlayerServiceTestCase

- (void)setUp
{
    [super setUp];
    
    self.cut = [[MGMItunesPlayerService alloc] initWithCoreDataAccess:nil serviceType:MGMAlbumServiceTypeItunes];
    self.dataConverter = (id)[self.cut createRemoteDataConverter];
}

- (MGMAlbum *)mockAlbumWithArtistName:(NSString *)artistName albumName:(NSString *)albumName
{
    MGMAlbum *mockAlbum = [self mockObject:[MGMAlbum class]];
    [MKTGiven([mockAlbum artistName]) willReturn:artistName];
    [MKTGiven([mockAlbum albumName]) willReturn:albumName];
    return mockAlbum;
}

- (void)testNoResults
{
    NSDictionary *results = @{
                              @"resultCount":@0,
                              @"results": @[]
                              };
    
    MGMAlbum *mockAlbum = [self mockAlbumWithArtistName:@"asdf" albumName:@"asdf"];
    MGMRemoteData *remoteData = [self.dataConverter.delegate convertJsonData:results key:mockAlbum];
    XCTAssert(remoteData);
    XCTAssertNil(remoteData.data);
}

- (void)testOneResults
{
    NSDictionary *results = @{
                              @"resultCount":@1,
                              @"results": @[
                                      @{
                                          @"wrapperType":@"collection",
                                          @"collectionType":@"Album",
                                          @"artistId":@13813453,
                                          @"collectionId":@326696273,
                                          @"amgArtistId":@558553,
                                          @"artistName":@"Mew",
                                          @"collectionName":@"No More Stories Are Told Today I'm Sorry They Washed Away No More Stories the World Is Grey I'm Tired Let's Wash Away (Bonus Track Version)",
                                          @"collectionCensoredName":@"No More Stories Are Told Today I'm Sorry They Washed Away No More Stories the World Is Grey I'm Tired Let's Wash Away (Bonus Track Version)",
                                          @"artistViewUrl":@"https://itunes.apple.com/gb/artist/mew/id13813453?uo=4",
                                          @"collectionViewUrl":@"https://itunes.apple.com/gb/album/no-more-stories-are-told-today/id326696273?uo=4",
                                          @"artworkUrl60":@"http://is5.mzstatic.com/image/pf/us/r30/Music/a0/c8/d5/mzi.cyapljqe.60x60-50.jpg",
                                          @"artworkUrl100":@"http://is2.mzstatic.com/image/pf/us/r30/Music/a0/c8/d5/mzi.cyapljqe.100x100-75.jpg",
                                          @"collectionPrice":@7.99,
                                          @"collectionExplicitness":@"notExplicit",
                                          @"trackCount":@17,
                                          @"copyright":@"℗ 2009 Sony Music Entertainment",
                                          @"country":@"GBR",
                                          @"currency":@"GBP",
                                          @"releaseDate":@"2009-08-13T07:00:00Z",
                                          @"primaryGenreName":@"Alternative"
                                          }
                                      ]
                              };
    
    MGMAlbum *mockAlbum = [self mockAlbumWithArtistName:@"Mew" albumName:@"No More Stories Are Told Today I'm Sorry They Washed Away No More Stories the World Is Grey I'm Tired Let's Wash Away"];
    MGMRemoteData *remoteData = [self.dataConverter.delegate convertJsonData:results key:mockAlbum];
    XCTAssert(remoteData);
    
    MGMAlbumMetadataDto *dto = remoteData.data;
    XCTAssert(dto);
    XCTAssertEqual(MGMAlbumServiceTypeItunes, dto.serviceType);
    XCTAssertEqual(@"https://itunes.apple.com/gb/album/no-more-stories-are-told-today/id326696273?uo=4", dto.value);
}

- (NSDictionary *) multipleResults
{
    return @{
             @"resultCount":@8,
             @"results": @[
                     @{
                         @"wrapperType":@"collection",
                         @"collectionType":@"Album",
                         @"artistId":@467464,
                         @"collectionId":@425465247,
                         @"amgArtistId":@5118,
                         @"artistName":@"Pearl Jam",
                         @"collectionName":@"Ten",
                         @"collectionCensoredName":@"Ten",
                         @"artistViewUrl":@"https://itunes.apple.com/gb/artist/pearl-jam/id467464?uo=4",
                         @"collectionViewUrl":@"https://itunes.apple.com/gb/album/ten/id425465247?uo=4",
                         @"artworkUrl60":@"http://is3.mzstatic.com/image/pf/us/r30/Music5/v4/15/56/08/15560891-8e84-8cd8-9e77-f65bc245ce3f/dj.romajxvb.60x60-50.jpg",
                         @"artworkUrl100":@"http://is5.mzstatic.com/image/pf/us/r30/Music5/v4/15/56/08/15560891-8e84-8cd8-9e77-f65bc245ce3f/dj.romajxvb.100x100-75.jpg",
                         @"collectionPrice":@6.99,
                         @"collectionExplicitness":@"notExplicit",
                         @"trackCount":@11,
                         @"copyright":@"℗ 1991 Sony Music Entertainment Inc.",
                         @"country":@"GBR",
                         @"currency":@"GBP",
                         @"releaseDate":@"1992-01-13T08:00:00Z",
                         @"primaryGenreName":@"Rock"
                         },
                     @{
                         @"wrapperType":@"collection",
                         @"collectionType":@"Album",
                         @"artistId":@467464,
                         @"collectionId":@410120430,
                         @"amgArtistId":@5118,
                         @"artistName":@"Pearl Jam",
                         @"collectionName":@"Live On 10 Legs",
                         @"collectionCensoredName":@"Live On 10 Legs",
                         @"artistViewUrl":@"https://itunes.apple.com/gb/artist/pearl-jam/id467464?uo=4",
                         @"collectionViewUrl":@"https://itunes.apple.com/gb/album/live-on-10-legs/id410120430?uo=4",
                         @"artworkUrl60":@"http://is4.mzstatic.com/image/pf/us/r30/Music/c4/78/5c/mzi.wnuscxie.60x60-50.jpg",
                         @"artworkUrl100":@"http://is4.mzstatic.com/image/pf/us/r30/Music/c4/78/5c/mzi.wnuscxie.100x100-75.jpg",
                         @"collectionPrice":@9.99,
                         @"collectionExplicitness":@"notExplicit",
                         @"trackCount":@20,
                         @"copyright":@"℗ 2010 Monkeywrench, Inc.",
                         @"country":@"GBR",
                         @"currency":@"GBP",
                         @"releaseDate":@"2010-01-01T08:00:00Z",
                         @"primaryGenreName":@"Rock"
                         }
                     ]
             };
}

- (void)testMultipleResultsExactMatch
{
    MGMAlbum *mockAlbum = [self mockAlbumWithArtistName:@"Pearl Jam" albumName:@"Live On 10 Legs"];
    MGMRemoteData *remoteData = [self.dataConverter.delegate convertJsonData:[self multipleResults] key:mockAlbum];
    XCTAssert(remoteData);
    
    MGMAlbumMetadataDto *dto = remoteData.data;
    XCTAssert(dto);
    XCTAssertEqual(MGMAlbumServiceTypeItunes, dto.serviceType);
    XCTAssertEqual(@"https://itunes.apple.com/gb/album/live-on-10-legs/id410120430?uo=4", dto.value);
}

- (void)testMultipleResultsNoExactMatch
{
    MGMAlbum *mockAlbum = [self mockAlbumWithArtistName:@"Pearl Jam" albumName:@"10"];
    MGMRemoteData *remoteData = [self.dataConverter.delegate convertJsonData:[self multipleResults] key:mockAlbum];
    XCTAssert(remoteData);
    
    MGMAlbumMetadataDto *dto = remoteData.data;
    XCTAssert(dto);
    XCTAssertEqual(MGMAlbumServiceTypeItunes, dto.serviceType);
    XCTAssertEqual(@"https://itunes.apple.com/gb/album/ten/id425465247?uo=4", dto.value);
}

@end
