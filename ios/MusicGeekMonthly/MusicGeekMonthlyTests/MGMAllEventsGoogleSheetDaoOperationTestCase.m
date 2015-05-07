//
//  MGMAllEventsGoogleSheetDaoOperationTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/04/15.
//  Copyright (c) 2015 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MGMAllEventsGoogleSheetDaoOperation.h"
#import "MGMRemoteJsonDataConverter.h"
#import "MGMEventDto.h"
#import "MGMAlbumMetadataDto.h"

@interface MGMAllEventsGoogleSheetDaoOperationTestCase : XCTestCase

@property (strong) MGMAllEventsGoogleSheetRemoteDataSource *cut;
@property (strong) MGMRemoteJsonDataConverter *dataConverter;

@end

@implementation MGMAllEventsGoogleSheetDaoOperationTestCase

- (void)setUp
{
    [super setUp];
    
    self.cut = [[MGMAllEventsGoogleSheetRemoteDataSource alloc] init];
    self.dataConverter = (id)[self.cut createRemoteDataConverter];
}

- (NSDate *)dateForYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDictionary *)noResults
{
    return @{
             @"version":@"1.0",
             @"encoding":@"UTF-8",
             @"feed":@{
                     @"xmlns":@"http://www.w3.org/2005/Atom",
                     @"xmlns$openSearch":@"http://a9.com/-/spec/opensearchrss/1.0/",
                     @"xmlns$gsx":@"http://schemas.google.com/spreadsheets/2006/extended",
                     @"id":@{
                             @"$t":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                             },
                     @"updated":@{
                             @"$t":@"2015-04-19T12:35:44.451Z"
                             },
                     @"category":@[
                             @{
                                 @"scheme":@"http://schemas.google.com/spreadsheets/2006",
                                 @"term":@"http://schemas.google.com/spreadsheets/2006#list"
                                 }
                             ],
                     @"title":@{
                             @"type":@"text",
                             @"$t":@"Sheet1"
                             },
                     @"link":@[
                             @{
                                 @"rel":@"alternate",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://docs.google.com/spreadsheets/d/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/pubhtml"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#feed",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#post",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"self",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values?alt\\u003djson"
                                 }
                             ],
                     @"author":@[
                             @{
                                 @"name":@{
                                         @"$t":@"hughesceri"
                                         },
                                 @"email":@{
                                         @"$t":@"hughesceri@gmail.com"
                                         }
                                 }
                             ],
                     @"openSearch$totalResults":@{
                             @"$t":@"0"
                             },
                     @"openSearch$startIndex":@{
                             @"$t":@"1"
                             }
                     }
             };
}

- (void)testNoResults
{
    MGMRemoteData *remoteData = [self.dataConverter convertJsonData:[self noResults] key:nil];
    XCTAssert(remoteData);
    
    NSArray *events = remoteData.data;
    XCTAssert(events);
    XCTAssertEqual(0, events.count);
}

- (NSDictionary *)simpleResult
{
    return @{
             @"version":@"1.0",
             @"encoding":@"UTF-8",
             @"feed":@{
                     @"xmlns":@"http://www.w3.org/2005/Atom",
                     @"xmlns$openSearch":@"http://a9.com/-/spec/opensearchrss/1.0/",
                     @"xmlns$gsx":@"http://schemas.google.com/spreadsheets/2006/extended",
                     @"id":@{
                             @"$t":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                             },
                     @"updated":@{
                             @"$t":@"2015-04-19T11:20:01.574Z"
                             },
                     @"category":@[
                             @{
                                 @"scheme":@"http://schemas.google.com/spreadsheets/2006",
                                 @"term":@"http://schemas.google.com/spreadsheets/2006#list"
                                 }
                             ],
                     @"title":@{
                             @"type":@"text",
                             @"$t":@"Sheet1"
                             },
                     @"link":@[
                             @{
                                 @"rel":@"alternate",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://docs.google.com/spreadsheets/d/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/pubhtml"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#feed",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#post",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"self",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values?alt\\u003djson"
                                 }
                             ],
                     @"author":@[
                             @{
                                 @"name":@{
                                         @"$t":@"hughesceri"
                                         },
                                 @"email":@{
                                         @"$t":@"hughesceri@gmail.com"
                                         }
                                 }
                             ],
                     @"openSearch$totalResults":@{
                             @"$t":@"46"
                             },
                     @"openSearch$startIndex":@{
                             @"$t":@"1"
                             },
                     @"entry":@[
                             @{
                                 @"id":@{
                                         @"$t":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values/cokwr"
                                         },
                                 @"updated":@{
                                         @"$t":@"2015-04-19T11:20:01.574Z"
                                         },
                                 @"category":@[
                                         @{
                                             @"scheme":@"http://schemas.google.com/spreadsheets/2006",
                                             @"term":@"http://schemas.google.com/spreadsheets/2006#list"
                                             }
                                         ],
                                 @"title":
                                     @{
                                         @"type":@"text",
                                         @"$t":@"1"
                                         },
                                 @"content":@{
                                         @"type":@"text",
                                         @"$t":@"date: 27/01/2011, playlist: 3SWdpu43D59vl0yzbAjie4"
                                         },
                                 @"link":@[
                                         @{
                                             @"rel":@"self",
                                             @"type":@"application/atom+xml",
                                             @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values/cokwr"
                                             }
                                         ],
                                 @"gsx$id":@{
                                         @"$t":@"1"
                                         },
                                 @"gsx$date":@{
                                         @"$t":@"27/01/2011"
                                         },
                                 @"gsx$playlist":@{
                                         @"$t":@"3SWdpu43D59vl0yzbAjie4"
                                         },
                                 @"gsx$classicartist":@{
                                         @"$t":@""
                                         },
                                 @"gsx$classicalbum":@{
                                         @"$t":@""
                                         },
                                 @"gsx$classicmbid":@{
                                         @"$t":@""
                                         },
                                 @"gsx$classicscore":@{
                                         @"$t":@""
                                         },
                                 @"gsx$classicspotifyid":@{
                                         @"$t":@""
                                         },
                                 @"gsx$newartist":@{
                                         @"$t":@""
                                         },
                                 @"gsx$newalbum":@{
                                         @"$t":@""
                                         },
                                 @"gsx$newmbid":@{
                                         @"$t":@""
                                         },
                                 @"gsx$newscore":@{
                                         @"$t":@""
                                         },
                                 @"gsx$newspotifyid":@{
                                         @"$t":@""
                                         }
                                 }
                             ]
                     }
             };
}

- (void)testSimpleResult
{
    MGMRemoteData *remoteData = [self.dataConverter convertJsonData:[self simpleResult] key:nil];
    XCTAssert(remoteData);
    
    NSArray *events = remoteData.data;
    XCTAssert(events);
    XCTAssertEqual(1, events.count);
    
    MGMEventDto *eventDto = events[0];
    XCTAssertEqualObjects(@1, eventDto.eventNumber);
    XCTAssertEqualObjects([self dateForYear:2011 month:1 day:27], eventDto.eventDate);
    XCTAssertEqualObjects(@"3SWdpu43D59vl0yzbAjie4", eventDto.playlistId);
    XCTAssertNil(eventDto.classicAlbum);
    XCTAssertNil(eventDto.newlyReleasedAlbum);
}

- (NSDictionary *)badResult
{
    return @{
             @"version":@"1.0",
             @"encoding":@"UTF-8",
             @"feed":@{
                     @"xmlns":@"http://www.w3.org/2005/Atom",
                     @"xmlns$openSearch":@"http://a9.com/-/spec/opensearchrss/1.0/",
                     @"xmlns$gsx":@"http://schemas.google.com/spreadsheets/2006/extended",
                     @"id":@{
                             @"$t":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                             },
                     @"updated":@{
                             @"$t":@"2015-04-19T11:20:01.574Z"
                             },
                     @"category":@[
                             @{
                                 @"scheme":@"http://schemas.google.com/spreadsheets/2006",
                                 @"term":@"http://schemas.google.com/spreadsheets/2006#list"
                                 }
                             ],
                     @"title":@{
                             @"type":@"text",
                             @"$t":@"Sheet1"
                             },
                     @"link":@[
                             @{
                                 @"rel":@"alternate",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://docs.google.com/spreadsheets/d/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/pubhtml"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#feed",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#post",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"self",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values?alt\\u003djson"
                                 }
                             ],
                     @"author":@[
                             @{
                                 @"name":@{
                                         @"$t":@"hughesceri"
                                         },
                                 @"email":@{
                                         @"$t":@"hughesceri@gmail.com"
                                         }
                                 }
                             ],
                     @"openSearch$totalResults":@{
                             @"$t":@"46"
                             },
                     @"openSearch$startIndex":@{
                             @"$t":@"1"
                             },
                     @"entry":@[
                             @{
                                 @"id":@{
                                         @"$t":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values/cpzh4"
                                         },
                                 @"updated":@{
                                         @"$t":@"2015-04-19T11:20:01.574Z"
                                         },
                                 @"category":@[
                                         @{
                                             @"scheme":@"http://schemas.google.com/spreadsheets/2006",
                                             @"term":@"http://schemas.google.com/spreadsheets/2006#list"
                                             }
                                         ],
                                 @"title":@{
                                         @"type":@"text",
                                         @"$t":@"-"
                                         },
                                 @"content":@{
                                         @"type":@"text",
                                         @"$t":@"date: -, playlist: -, classicartist: -, classicalbum: -, classicmbid: -, classicscore: -, classicspotifyid: -, newartist: -, newalbum: -, newmbid: -, newscore: -, newspotifyid: -"
                                         },
                                 @"link":@[
                                         @{
                                             @"rel":@"self",
                                             @"type":@"application/atom+xml",
                                             @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values/cpzh4"
                                             }
                                         ],
                                 @"gsx$id":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$date":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$playlist":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$classicartist":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$classicalbum":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$classicmbid":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$classicscore":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$classicspotifyid":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$newartist":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$newalbum":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$newmbid":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$newscore":@{
                                         @"$t":@"-"
                                         },
                                 @"gsx$newspotifyid":@{
                                         @"$t":@"-"
                                         }
                                 }
                             ]
                     }
             };
}

- (void)testBadResult
{
    MGMRemoteData *remoteData = [self.dataConverter convertJsonData:[self badResult] key:nil];
    XCTAssert(remoteData);
    
    NSArray *events = remoteData.data;
    XCTAssert(events);
    XCTAssertEqual(0, events.count);
}

- (NSDictionary *)goodResult
{
    return @{
             @"version":@"1.0",
             @"encoding":@"UTF-8",
             @"feed":@{
                     @"xmlns":@"http://www.w3.org/2005/Atom",
                     @"xmlns$openSearch":@"http://a9.com/-/spec/opensearchrss/1.0/",
                     @"xmlns$gsx":@"http://schemas.google.com/spreadsheets/2006/extended",
                     @"id":@{
                             @"$t":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                             },
                     @"updated":@{
                             @"$t":@"2015-04-19T11:20:01.574Z"
                             },
                     @"category":@[
                             @{
                                 @"scheme":@"http://schemas.google.com/spreadsheets/2006",
                                 @"term":@"http://schemas.google.com/spreadsheets/2006#list"
                                 }
                             ],
                     @"title":@{
                             @"type":@"text",
                             @"$t":@"Sheet1"
                             },
                     @"link":@[
                             @{
                                 @"rel":@"alternate",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://docs.google.com/spreadsheets/d/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/pubhtml"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#feed",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"http://schemas.google.com/g/2005#post",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
                                 },
                             @{
                                 @"rel":@"self",
                                 @"type":@"application/atom+xml",
                                 @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values?alt\\u003djson"
                                 }
                             ],
                     @"author":@[
                             @{
                                 @"name":@{
                                         @"$t":@"hughesceri"
                                         },
                                 @"email":@{
                                         @"$t":@"hughesceri@gmail.com"
                                         }
                                 }
                             ],
                     @"openSearch$totalResults":@{
                             @"$t":@"46"
                             },
                     @"openSearch$startIndex":@{
                             @"$t":@"1"
                             },
                     @"entry":@[
                             @{
                                 @"id":@{
                                         @"$t":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values/cre1l"
                                         },
                                 @"updated":@{
                                         @"$t":@"2015-04-19T11:20:01.574Z"
                                         },
                                 @"category":@[
                                         @{
                                             @"scheme":@"http://schemas.google.com/spreadsheets/2006",
                                             @"term":@"http://schemas.google.com/spreadsheets/2006#list"
                                             }
                                         ],
                                 @"title":@{
                                         @"type":@"text",
                                         @"$t":@"2"
                                         },
                                 @"content":@{
                                         @"type":@"text",
                                         @"$t":@"date: 17/02/2011, playlist: 1luGunqHuU7DIdkZXhH3XD, classicartist: Stevie Wonder, classicalbum: Songs In The Key Of Life, classicmbid: 5d3014fb-6761-4626-ab83-985d74177109, classicscore: 6.7, classicspotifyid: 0ekrCyUT01BzU89QbiKcaI, newartist: Fujiya \\u0026 Miyagi, newalbum: Ventriloquizzing, newmbid: 4250910a-5d2b-4ce8-8d25-f4afbae0ff79, newscore: 6.6, newspotifyid: 7n8LCYB1fUiGSJI9BpIVFO"
                                         },
                                 @"link":@[
                                         @{
                                             @"rel":@"self",
                                             @"type":@"application/atom+xml",
                                             @"href":@"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values/cre1l"
                                             }
                                         ],
                                 @"gsx$id":@{
                                         @"$t":@"2"
                                         },
                                 @"gsx$date":@{
                                         @"$t":@"17/02/2011"
                                         },
                                 @"gsx$playlist":@{
                                         @"$t":@"1luGunqHuU7DIdkZXhH3XD"
                                         },
                                 @"gsx$classicartist":@{
                                         @"$t":@"Stevie Wonder"
                                         },
                                 @"gsx$classicalbum":@{
                                         @"$t":@"Songs In The Key Of Life"
                                         },
                                 @"gsx$classicmbid":@{
                                         @"$t":@"5d3014fb-6761-4626-ab83-985d74177109"
                                         },
                                 @"gsx$classicscore":@{
                                         @"$t":@"6.7"
                                         },
                                 @"gsx$classicspotifyid":@{
                                         @"$t":@""
                                         },
                                 @"gsx$newartist":@{
                                         @"$t":@"Fujiya \\u0026 Miyagi"
                                         },
                                 @"gsx$newalbum":@{
                                         @"$t":@"Ventriloquizzing"
                                         },
                                 @"gsx$newmbid":@{
                                         @"$t":@"4250910a-5d2b-4ce8-8d25-f4afbae0ff79"
                                         },
                                 @"gsx$newscore":@{
                                         @"$t":@"6.6"
                                         },
                                 @"gsx$newspotifyid":@{
                                         @"$t":@"7n8LCYB1fUiGSJI9BpIVFO"
                                         }
                                 }
                             ]
                     }
             };
}

- (void)testGoodResult
{
    MGMRemoteData *remoteData = [self.dataConverter convertJsonData:[self goodResult] key:nil];
    XCTAssert(remoteData);
    
    NSArray *events = remoteData.data;
    XCTAssert(events);
    XCTAssertEqual(1, events.count);
    
    MGMEventDto *eventDto = events[0];
    XCTAssertEqualObjects(@2, eventDto.eventNumber);
    XCTAssertEqualObjects([self dateForYear:2011 month:2 day:17], eventDto.eventDate);
    XCTAssertEqualObjects(@"1luGunqHuU7DIdkZXhH3XD", eventDto.playlistId);
    
    MGMAlbumDto *albumDto = eventDto.classicAlbum;
    XCTAssert(albumDto);
    XCTAssertEqualObjects(@"Songs In The Key Of Life", albumDto.albumName);
    XCTAssertEqualObjects(@"Stevie Wonder", albumDto.artistName);
    XCTAssertEqualObjects(@"5d3014fb-6761-4626-ab83-985d74177109", albumDto.albumMbid);
    XCTAssertEqualObjects(@6.7f, albumDto.score);
    XCTAssertEqual(1, albumDto.metadata.count);
    MGMAlbumMetadataDto *albumMetadata = albumDto.metadata[0];
    XCTAssertEqual(MGMAlbumServiceTypeLastFm, albumMetadata.serviceType);
    XCTAssertEqualObjects(@"Stevie Wonder", albumMetadata.value);
    
    albumDto = eventDto.newlyReleasedAlbum;
    XCTAssert(albumDto);
    XCTAssertEqualObjects(@"Ventriloquizzing", albumDto.albumName);
    XCTAssertEqualObjects(@"Fujiya \\u0026 Miyagi", albumDto.artistName);
    XCTAssertEqualObjects(@"4250910a-5d2b-4ce8-8d25-f4afbae0ff79", albumDto.albumMbid);
    XCTAssertEqualObjects(@6.6f, albumDto.score);
    XCTAssertEqual(2, albumDto.metadata.count);
    albumMetadata = albumDto.metadata[0];
    XCTAssertEqual(MGMAlbumServiceTypeSpotify, albumMetadata.serviceType);
    XCTAssertEqualObjects(@"7n8LCYB1fUiGSJI9BpIVFO", albumMetadata.value);
    albumMetadata = albumDto.metadata[1];
    XCTAssertEqual(MGMAlbumServiceTypeLastFm, albumMetadata.serviceType);
    XCTAssertEqualObjects(@"Fujiya \\u0026 Miyagi", albumMetadata.value);
}

@end
