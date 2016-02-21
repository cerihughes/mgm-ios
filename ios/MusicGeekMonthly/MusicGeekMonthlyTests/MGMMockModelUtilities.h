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

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter; // dd/MM/yyyy

+ (id)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMockGenerator:(id<MGMMockGenerator>)mockGenerator;

- (MGMAlbum *)mockAlbumWithArtistName:(NSString *)artistName
                            albumName:(NSString *)albumName
                                score:(float)score
                   coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMEvent *)mockEventWithEventNumber:(NSUInteger)eventNumber
                       eventDateString:(NSString *)eventDateString // @"dd/MM/yyyy"
                            playlistId:(NSString *)playlistId
                     classicArtistName:(NSString *)classicArtistName
                      classicAlbumName:(NSString *)classicAlbumName
                     classicAlbumScore:(float)classicAlbumScore
               newlyReleasedArtistName:(NSString *)newlyReleasedArtistName
                newlyReleasedAlbumName:(NSString *)newlyReleasedAlbumName
               newlyReleasedAlbumScore:(float)newlyReleasedAlbumScore
                    coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMPlaylist *)mockPlaylistWithPlaylistId:(NSString *)playlistId
                                       name:(NSString *)name
                         coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMTimePeriod *)mockTimePeriodWithStartDateString:(NSString *)startDateString // @"dd/MM/yyyy"
                                       endDateString:(NSString *)endDateString // @"dd/MM/yyyy"
                                  coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMWeeklyChart *)mockWeeklyChartWithStartDateString:(NSString *)startDateString // @"dd/MM/yyyy"
                                         endDateString:(NSString *)endDateString // @"dd/MM/yyyy"
                                    coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

- (MGMChartEntry *)mockChartEntryWithListeners:(NSUInteger)listeners
                                          rank:(NSUInteger)rank
                                    artistName:(NSString *)artistName
                                     albumName:(NSString *)albumName
                                    albumScore:(float)albumScore
                            coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock;

@end
