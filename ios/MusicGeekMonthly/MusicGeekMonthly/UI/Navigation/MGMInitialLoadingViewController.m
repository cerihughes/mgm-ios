//
//  MGMInitialLoadingViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMInitialLoadingViewController.h"

#import "MGMAlbum.h"
#import "MGMBackgroundAlbumArtCollection.h"
#import "MGMChartEntry.h"
#import "MGMCore.h"
#import "MGMCoreDataAccess.h"
#import "MGMDao.h"
#import "MGMDaoData.h"
#import "MGMEvent.h"
#import "MGMInitialLoadingView.h"
#import "MGMLastFmConstants.h"
#import "MGMTimePeriod.h"
#import "MGMWeeklyChart.h"
#import "MGMUI.h"
#import "UIViewController+MGMAdditions.h"

@implementation MGMInitialLoadingViewController

- (void) loadView
{
    MGMInitialLoadingView* view = [[MGMInitialLoadingView alloc] initWithFrame:[self fullscreenRect]];

    self.view = view;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MGMInitialLoadingView* view = (MGMInitialLoadingView*) self.view;
    [view setOperationInProgress:YES];

    // Preload data if needed
    [self.core.dao preloadEvents:^(MGMDaoData* events) {
        NSArray* eventMoids = events.data;
        [self.core.dao preloadTimePeriods:^(MGMDaoData* timePeriods) {
            NSArray* timePeriodsArray = (NSArray*)timePeriods.data;
            if (timePeriodsArray.count == 1)
            {
                MGMTimePeriod* timePeriod = [self.core.coreDataAccess mainThreadVersion:timePeriodsArray[0]];
                [self.core.dao preloadWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMDaoData* weeklyChartData) {
                    [self preloadCompleteWithEventMoids:eventMoids weeklyChartMoid:weeklyChartData.data];
                }];
            }
            else if (timePeriodsArray.count > 1)
            {
                // Data has already been loaded from server.
                MGMTimePeriod* timePeriod = [self.core.coreDataAccess mainThreadVersion:timePeriodsArray[0]];
                [self.core.dao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMDaoData* weeklyChartData) {
                    [self preloadCompleteWithEventMoids:eventMoids weeklyChartMoid:weeklyChartData.data];
                }];
            }
            else
            {
                // What's happened here?
                [self preloadCompleteWithEventMoids:eventMoids weeklyChartMoid:nil];
            }
        }];
    }];
}

- (void) preloadCompleteWithEventMoids:(NSArray*)eventMoids weeklyChartMoid:(NSManagedObjectID*)weeklyChartMoid
{
    NSArray* events = [self.core.coreDataAccess mainThreadVersions:eventMoids];
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess mainThreadVersion:weeklyChartMoid];
    MGMAlbumImageSize preferredSize = self.ui.ipad ? MGMAlbumImageSize128 : MGMAlbumImageSize64;
    MGMBackgroundAlbumArtCollection* albumArt = [self albumArtForEvents:events weeklyChart:weeklyChart preferredSize:preferredSize];

    MGMInitialLoadingView* view = (MGMInitialLoadingView*) self.view;
    [view setOperationInProgress:NO];
    [self.delegate initialisationComplete:albumArt];
}

- (MGMBackgroundAlbumArtCollection*) albumArtForEvents:(NSArray*)events weeklyChart:(MGMWeeklyChart*)weeklyChart preferredSize:(MGMAlbumImageSize)preferredSize
{
    MGMBackgroundAlbumArtCollection* collection = [[MGMBackgroundAlbumArtCollection alloc] init];

    // Maybe this should be done by a service? Add "needsHttpConnection" as a property to determine whether a service can generate urls without a connection?
    for (MGMEvent* event in events)
    {
        MGMAlbum* classicAlbum = event.classicAlbum;
        if (classicAlbum.albumMbid)
        {
            NSString* classicAlbumArt = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, classicAlbum.albumMbid, MUSIC_BRAINZ_IMAGE_250];
            [collection addAlbumArtUrlArray:@[classicAlbumArt]];
        }

        MGMAlbum* newlyReleasedAlbum = event.newlyReleasedAlbum;
        if (newlyReleasedAlbum.albumMbid)
        {
            NSString* newlyReleasedAlbumArt = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, newlyReleasedAlbum.albumMbid, MUSIC_BRAINZ_IMAGE_250];
            [collection addAlbumArtUrlArray:@[newlyReleasedAlbumArt]];
        }
    }

    for (MGMChartEntry* entry in weeklyChart.chartEntries)
    {
        MGMAlbum* randomAlbum = entry.album;
        NSArray* urls = [randomAlbum bestImageUrlsWithPreferredSize:preferredSize];
        if (urls.count > 0)
        {
            [collection addAlbumArtUrlArray:urls];
        }
    }

    return collection;
}


@end
