//
//  MGMMockModelUtilities.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMMockModelUtilities.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "MGMAlbum.h"
#import "MGMCoreDataAccess.h"
#import "MGMEvent.h"
#import "MGMMockGenerator.h"
#import "MGMPlaylist.h"
#import "MGMPlaylistItem.h"

@interface MGMMockModelUtilities ()

@property (nonatomic, weak) id<MGMMockGenerator> mockGenerator;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MGMMockModelUtilities

- (instancetype)initWithMockGenerator:(id<MGMMockGenerator>)mockGenerator
{
    self = [super init];
    if (self) {
        _mockGenerator = mockGenerator;

        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd/MM/yyyy";
    }
    return self;
}

- (NSManagedObjectID *)mockMoidForAlbumWithArtistName:(NSString *)artistName
                                            albumName:(NSString *)albumName
                                                score:(float)score
                               fromCoreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    MGMAlbum *album = [self mockAlbumWithArtistName:artistName albumName:albumName score:score];
    NSManagedObjectID *moid = [self.mockGenerator mockObject:[NSManagedObjectID class]];
    [MKTGiven([coreDataAccessMock mainThreadVersion:moid]) willReturn:album];
    return moid;
}

- (MGMAlbum *)mockAlbumWithArtistName:(NSString *)artistName
                            albumName:(NSString *)albumName
                                score:(float)score
{
    MGMAlbum *album = [self.mockGenerator mockObject:[MGMAlbum class]];
    [MKTGiven([album artistName]) willReturn:artistName];
    [MKTGiven([album albumName]) willReturn:albumName];
    [MKTGiven([album score]) willReturn:@(score)];
    [[MKTGiven([album bestImageUrlsWithPreferredSize:0]) withMatcher:anything()] willReturn:@[artistName, albumName]];
    return album;
}

- (MGMEvent *)mockEventWithEventNumber:(NSUInteger)eventNumber
                       eventDateString:(NSString *)eventDateString // @"dd/MM/yyyy"
                            playlistId:(NSString *)playlistId
                     classicArtistName:(NSString *)classicArtistName
                      classicAlbumName:(NSString *)classicAlbumName
                     classicAlbumScore:(float)classicAlbumScore
               newlyReleasedArtistName:(NSString *)newlyReleasedArtistName
                newlyReleasedAlbumName:(NSString *)newlyReleasedAlbumName
               newlyReleasedAlbumScore:(float)newlyReleasedAlbumScore
{
    MGMEvent *event = [self.mockGenerator mockObject:[MGMEvent class]];
    NSDate *eventDate = [self.dateFormatter dateFromString:eventDateString];
    [MKTGiven([event eventNumber]) willReturn:@(eventNumber)];
    [MKTGiven([event eventDate]) willReturn:eventDate];
    [MKTGiven([event playlistId]) willReturn:playlistId];
    [MKTGiven([event groupHeader]) willReturn:@"Group Header"];
    [MKTGiven([event groupValue]) willReturn:eventDateString];

    MGMAlbum *classicAlbum = [self mockAlbumWithArtistName:classicArtistName albumName:classicAlbumName score:classicAlbumScore];
    MGMAlbum *newlyReleasedAlbum = [self mockAlbumWithArtistName:newlyReleasedArtistName albumName:newlyReleasedAlbumName score:newlyReleasedAlbumScore];

    [MKTGiven([event classicAlbum]) willReturn:classicAlbum];
    [MKTGiven([event newlyReleasedAlbum]) willReturn:newlyReleasedAlbum];
    return event;
}

- (NSManagedObjectID *)mockMoidForPlaylistWithPlaylistId:(NSString *)playlistId
                                                    name:(NSString *)name
                                  fromCoreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    MGMPlaylist *playlist = [self mockPlaylistWithPlaylistId:playlistId name:name];
    NSManagedObjectID *moid = [self.mockGenerator mockObject:[NSManagedObjectID class]];
    [MKTGiven([coreDataAccessMock mainThreadVersion:moid]) willReturn:playlist];
    return moid;
}

- (MGMPlaylist *)mockPlaylistWithPlaylistId:(NSString *)playlistId
                                       name:(NSString *)name
{
    MGMPlaylist *playlist = [self.mockGenerator mockObject:[MGMPlaylist class]];
    [MKTGiven([playlist playlistId]) willReturn:playlistId];
    [MKTGiven([playlist name]) willReturn:name];

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 25; i++) {
        MGMPlaylistItem *playlistItem = [self.mockGenerator mockObject:[MGMPlaylistItem class]];
        NSString *track = [NSString stringWithFormat:@"Track %d", i];
        [MKTGiven([playlistItem artist]) willReturn:[NSString stringWithFormat:@"Artist %d", i]];
        [MKTGiven([playlistItem album]) willReturn:[NSString stringWithFormat:@"Album %d", i]];
        [MKTGiven([playlistItem track]) willReturn:track];
        [[MKTGiven([playlistItem bestImageUrlsWithPreferredSize:0]) withMatcher:anything()] willReturn:@[track]];
        [MKTGiven([playlistItem playlist]) willReturn:playlist];
        [array addObject:playlistItem];
    }
    [MKTGiven([playlist playlistItems]) willReturn:[NSOrderedSet orderedSetWithArray:array]];
    return playlist;
}

@end
