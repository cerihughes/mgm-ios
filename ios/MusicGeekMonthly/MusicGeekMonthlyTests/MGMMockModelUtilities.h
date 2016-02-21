//
//  MGMMockModelUtilities.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGMMockGenerator;
@class MGMAlbum;
@class MGMChartEntry;
@class MGMCoreDataAccess;
@class MGMEvent;
@class MGMPlaylist;
@class MGMTimePeriod;
@class MGMWeeklyChart;
@class NSManagedObjectID;

@interface MGMMockModelUtilities : NSObject

+ (id)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMockGenerator:(id<MGMMockGenerator>)mockGenerator;

- (NSManagedObjectID *)mockMoidForAlbumWithArtistName:(NSString *)artistName
                                            albumName:(NSString *)albumName
                                                score:(float)score
                               fromCoreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMAlbum *)mockAlbumWithArtistName:(NSString *)artistName
                            albumName:(NSString *)albumName
                                score:(float)score;

- (MGMEvent *)mockEventWithEventNumber:(NSUInteger)eventNumber
                       eventDateString:(NSString *)eventDateString // @"dd/MM/yyyy"
                            playlistId:(NSString *)playlistId
                     classicArtistName:(NSString *)classicArtistName
                      classicAlbumName:(NSString *)classicAlbumName
                     classicAlbumScore:(float)classicAlbumScore
               newlyReleasedArtistName:(NSString *)newlyReleasedArtistName
                newlyReleasedAlbumName:(NSString *)newlyReleasedAlbumName
               newlyReleasedAlbumScore:(float)newlyReleasedAlbumScore;

- (NSManagedObjectID *)mockMoidForPlaylistWithPlaylistId:(NSString *)playlistId
                                                    name:(NSString *)name
                                  fromCoreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMPlaylist *)mockPlaylistWithPlaylistId:(NSString *)playlistId
                                       name:(NSString *)name;

- (MGMTimePeriod *)mockTimePeriodWithStartDateString:(NSString *)startDateString // @"dd/MM/yyyy"
                                       endDateString:(NSString *)endDateString; // @"dd/MM/yyyy"

- (NSManagedObjectID *)mockMoidForWeeklyChartWithStartDateString:(NSString *)startDateString // @"dd/MM/yyyy"
                                                   endDateString:(NSString *)endDateString // @"dd/MM/yyyy"
                                          fromCoreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMWeeklyChart *)mockWeeklyChartWithStartDateString:(NSString *)startDateString // @"dd/MM/yyyy"
                                         endDateString:(NSString *)endDateString; // @"dd/MM/yyyy"

- (MGMChartEntry *)mockChartEntryWithListeners:(NSUInteger)listeners
                                          rank:(NSUInteger)rank
                                    artistName:(NSString *)artistName
                                     albumName:(NSString *)albumName
                                    albumScore:(float)albumScore;
@end
