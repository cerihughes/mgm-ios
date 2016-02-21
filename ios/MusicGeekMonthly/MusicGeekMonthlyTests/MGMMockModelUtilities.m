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
#import "MGMChartEntry.h"
#import "MGMCoreDataAccess.h"
#import "MGMEvent.h"
#import "MGMMockGenerator.h"
#import "MGMPlaylist.h"
#import "MGMPlaylistItem.h"
#import "MGMTimePeriod.h"
#import "MGMWeeklyChart.h"

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

- (void)setExpectationsForManagedObject:(NSManagedObject *)managedObject
                     coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    NSManagedObjectID *moid = [self.mockGenerator mockObject:[NSManagedObjectID class]];
    [MKTGiven([coreDataAccessMock mainThreadVersion:moid]) willReturn:managedObject];
    [MKTGiven([managedObject objectID]) willReturn:moid];
}

- (MGMAlbum *)mockAlbumWithArtistName:(NSString *)artistName
                            albumName:(NSString *)albumName
                                score:(float)score
                   coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    MGMAlbum *album = [self.mockGenerator mockObject:[MGMAlbum class]];
    [MKTGiven([album artistName]) willReturn:artistName];
    [MKTGiven([album albumName]) willReturn:albumName];
    if (score > 0.0f) {
        [MKTGiven([album score]) willReturn:@(score)];
    }
    [[MKTGiven([album bestImageUrlsWithPreferredSize:0]) withMatcher:anything()] willReturn:@[artistName, albumName]];

    [self setExpectationsForManagedObject:album coreDataAccessMock:coreDataAccessMock];

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
                    coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    MGMEvent *event = [self.mockGenerator mockObject:[MGMEvent class]];
    NSDate *eventDate = [self.dateFormatter dateFromString:eventDateString];
    [MKTGiven([event eventNumber]) willReturn:@(eventNumber)];
    [MKTGiven([event eventDate]) willReturn:eventDate];
    [MKTGiven([event playlistId]) willReturn:playlistId];
    [MKTGiven([event groupHeader]) willReturn:@"Group Header"];
    [MKTGiven([event groupValue]) willReturn:eventDateString];

    MGMAlbum *classicAlbum = [self mockAlbumWithArtistName:classicArtistName
                                                 albumName:classicAlbumName
                                                     score:classicAlbumScore
                                        coreDataAccessMock:coreDataAccessMock];
    MGMAlbum *newlyReleasedAlbum = [self mockAlbumWithArtistName:newlyReleasedArtistName
                                                       albumName:newlyReleasedAlbumName
                                                           score:newlyReleasedAlbumScore
                                              coreDataAccessMock:coreDataAccessMock];

    [MKTGiven([event classicAlbum]) willReturn:classicAlbum];
    [MKTGiven([event newlyReleasedAlbum]) willReturn:newlyReleasedAlbum];

    [self setExpectationsForManagedObject:event coreDataAccessMock:coreDataAccessMock];

    return event;
}

- (MGMPlaylist *)mockPlaylistWithPlaylistId:(NSString *)playlistId
                                       name:(NSString *)name
                         coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
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

        [self setExpectationsForManagedObject:playlistItem coreDataAccessMock:coreDataAccessMock];

        [array addObject:playlistItem];
    }
    [MKTGiven([playlist playlistItems]) willReturn:[NSOrderedSet orderedSetWithArray:array]];

    [self setExpectationsForManagedObject:playlist coreDataAccessMock:coreDataAccessMock];

    return playlist;
}

- (MGMTimePeriod *)mockTimePeriodWithStartDateString:(NSString *)startDateString // @"dd/MM/yyyy"
                                       endDateString:(NSString *)endDateString // @"dd/MM/yyyy"
                                  coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    MGMTimePeriod *timePeriod = [self.mockGenerator mockObject:[MGMTimePeriod class]];
    NSDate *startDate = [self.dateFormatter dateFromString:startDateString];
    NSDate *endDate = [self.dateFormatter dateFromString:endDateString];
    [MKTGiven([timePeriod startDate]) willReturn:startDate];
    [MKTGiven([timePeriod endDate]) willReturn:endDate];
    [MKTGiven([timePeriod groupHeader]) willReturn:@"Group Header"];
    [MKTGiven([timePeriod groupValue]) willReturn:[NSString stringWithFormat:@"%@ - %@", startDateString, endDateString]];

    [self setExpectationsForManagedObject:timePeriod coreDataAccessMock:coreDataAccessMock];

    return timePeriod;
}

- (MGMWeeklyChart *)mockWeeklyChartWithStartDateString:(NSString *)startDateString // @"dd/MM/yyyy"
                                         endDateString:(NSString *)endDateString // @"dd/MM/yyyy"
                                    coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    MGMWeeklyChart *weeklyChart = [self.mockGenerator mockObject:[MGMWeeklyChart class]];
    NSDate *startDate = [self.dateFormatter dateFromString:startDateString];
    NSDate *endDate = [self.dateFormatter dateFromString:endDateString];
    [MKTGiven([weeklyChart startDate]) willReturn:startDate];
    [MKTGiven([weeklyChart endDate]) willReturn:endDate];

    NSMutableArray *array = [NSMutableArray array];
    for (int rank = 1; rank < 26; rank++) {
        float score = (rank % 4) * 2.5f;
        MGMChartEntry *chartEntry = [self mockChartEntryWithListeners:rank * 2
                                                                 rank:rank
                                                           artistName:[NSString stringWithFormat:@"CHART ARTIST %d", rank]
                                                            albumName:[NSString stringWithFormat:@"CHART ALBUM %d", rank]
                                                           albumScore:score
                                                   coreDataAccessMock:coreDataAccessMock];
        [array addObject:chartEntry];
    }

    [MKTGiven([weeklyChart chartEntries]) willReturn:[NSOrderedSet orderedSetWithArray:array]];

    [self setExpectationsForManagedObject:weeklyChart coreDataAccessMock:coreDataAccessMock];

    return weeklyChart;
}

- (MGMChartEntry *)mockChartEntryWithListeners:(NSUInteger)listeners
                                          rank:(NSUInteger)rank
                                    artistName:(NSString *)artistName
                                     albumName:(NSString *)albumName
                                    albumScore:(float)albumScore
                            coreDataAccessMock:(MGMCoreDataAccess *)coreDataAccessMock
{
    MGMChartEntry *chartEntry = [self.mockGenerator mockObject:[MGMChartEntry class]];
    if (listeners > 0) {
        [MKTGiven([chartEntry listeners]) willReturn:@(listeners)];
    }
    if (rank > 0) {
        [MKTGiven([chartEntry rank]) willReturn:@(rank)];
    }

    MGMAlbum *album = [self mockAlbumWithArtistName:artistName
                                          albumName:albumName
                                              score:albumScore
                                 coreDataAccessMock:coreDataAccessMock];

    [MKTGiven([chartEntry album]) willReturn:album];

    [self setExpectationsForManagedObject:chartEntry coreDataAccessMock:coreDataAccessMock];

    return chartEntry;
}

@end
