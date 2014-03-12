//
//  MGMInitialLoadingViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMInitialLoadingViewController.h"

#import "MGMInitialLoadingView.h"
#import "MGMTimePeriod.h"

@implementation MGMInitialLoadingViewController

- (void) loadView
{
    MGMInitialLoadingView* view = [[MGMInitialLoadingView alloc] initWithFrame:[self fullscreenRect]];

    self.view = view;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    MGMInitialLoadingView* view = (MGMInitialLoadingView*) self.view;
    [view setOperationInProgress:YES];

    // Preload data if needed
    [self.core.dao preloadEvents:^(MGMDaoData* events) {
        [self.core.dao preloadTimePeriods:^(MGMDaoData* timePeriods) {
            NSArray* timePeriodsArray = (NSArray*)timePeriods.data;
            if (timePeriodsArray.count == 1)
            {
                MGMTimePeriod* timePeriod = [self.core.coreDataAccess threadVersion:timePeriodsArray[0]];
                [self.core.dao preloadWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate completion:^(MGMDaoData* weeklyChart) {
                    [view setOperationInProgress:NO];
                    [self.delegate initialisationComplete];
                }];
            }
        }];
    }];
}

@end
