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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Preload data if needed
        [self.core.dao preloadEvents];
        MGMDaoData* timePeriods = [self.core.dao preloadTimePeriods];
        NSArray* timePeriodsArray = (NSArray*)timePeriods.data;
        if (timePeriodsArray.count == 1)
        {
            MGMTimePeriod* timePeriod = timePeriodsArray[0];
            [self.core.dao preloadWeeklyChartForStartDate:timePeriod.startDate endDate:timePeriod.endDate];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [view setOperationInProgress:NO];
            [self.delegate initialisationComplete];
        });
    });
}

@end
