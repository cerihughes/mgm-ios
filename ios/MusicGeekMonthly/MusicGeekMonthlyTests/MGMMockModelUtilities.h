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
@class MGMCoreDataAccess;
@class MGMEvent;
@class MGMPlaylist;
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

@end
