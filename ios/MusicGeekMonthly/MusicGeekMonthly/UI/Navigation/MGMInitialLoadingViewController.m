//
//  MGMInitialLoadingViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMInitialLoadingViewController.h"

#import "MGMChartEntry.h"
#import "MGMInitialLoadingView.h"
#import "MGMTimePeriod.h"
#import "MGMWeeklyChart.h"

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
        [self.core.dao preloadTimePeriods:^(MGMDaoData* timePeriods) {
            NSArray* timePeriodsArray = (NSArray*)timePeriods.data;
            if (timePeriodsArray.count == 1)
            {
                MGMTimePeriod* timePeriod = [self.core.coreDataAccess mainThreadVersion:timePeriodsArray[0]];
                [self.core.dao preloadWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMDaoData* weeklyChartData) {
                    [self preloadCompleteWithWeeklyChartMoid:weeklyChartData.data];
                }];
            }
            else if (timePeriodsArray.count > 1)
            {
                // Data has already been loaded from server.
                MGMTimePeriod* timePeriod = [self.core.coreDataAccess mainThreadVersion:timePeriodsArray[0]];
                [self.core.dao fetchWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMDaoData* weeklyChartData) {
                    [self preloadCompleteWithWeeklyChartMoid:weeklyChartData.data];
                }];
            }
            else
            {
                // What's happened here?
                [self preloadCompleteWithWeeklyChartMoid:nil];
            }
        }];
    }];
}

- (void) preloadCompleteWithWeeklyChartMoid:(NSManagedObjectID*)weeklyChartMoid
{
    MGMWeeklyChart* weeklyChart = [self.core.coreDataAccess mainThreadVersion:weeklyChartMoid];
    MGMAlbumImageSize preferredSize = self.ui.ipad ? MGMAlbumImageSize128 : MGMAlbumImageSize64;
    MGMBackgroundAlbumArtCollection* albumArt = [self albumArtForWeeklyChart:weeklyChart preferredSize:preferredSize];

    MGMInitialLoadingView* view = (MGMInitialLoadingView*) self.view;
    [view setOperationInProgress:NO];
    [self.delegate initialisationComplete:albumArt];
}

- (MGMBackgroundAlbumArtCollection*) albumArtForWeeklyChart:(MGMWeeklyChart*)weeklyChart preferredSize:(MGMAlbumImageSize)preferredSize
{
    MGMBackgroundAlbumArtCollection* collection = [[MGMBackgroundAlbumArtCollection alloc] init];
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
