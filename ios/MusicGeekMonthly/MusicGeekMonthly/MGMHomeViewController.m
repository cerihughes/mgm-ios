
//
//  MGMHomeViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeViewController.h"

#import "MGMEvent.h"
#import "MGMHomeView.h"

@interface MGMHomeViewController () <MGMAbstractEventViewDelegate>

@property (strong) NSManagedObjectID* eventMoid;

@end

@implementation MGMHomeViewController

- (void) loadView
{
    [super loadView];

    MGMHomeView* homeView = [[MGMHomeView alloc] initWithFrame:[self fullscreenRect]];

    homeView.delegate = self;
    self.view = homeView;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        [self.core.daoFactory.eventsDao fetchAllEvents:^(NSArray* fetchedEvents, NSError* fetchError) {
            if (fetchError && fetchedEvents.count > 0)
            {
                [self logError:fetchError];
            }

            if (fetchedEvents.count > 0) {
                MGMEvent* event = [fetchedEvents objectAtIndex:0];
                self.eventMoid = event.objectID;
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self displayEventWithMoid:self.eventMoid];
                });
            }
            else
            {
                [self showError:fetchError];
            }
        }];
    });
}

- (void) displayEventWithMoid:(NSManagedObjectID*)eventMoid
{
    MGMEvent* event = [self.core.daoFactory.coreDataDao threadVersion:eventMoid];
    [self displayEvent:event];
}

- (void) displayEvent:(MGMEvent*)event
{
    [super displayEvent:event];

    MGMHomeView* homeView = (MGMHomeView*)self.view;
    [homeView setNextEventDate:event.eventDate];
}

@end
