
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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MGMDaoData* eventsData = [self.core.dao fetchAllEvents];
        NSError* fetchError = eventsData.error;
        NSArray* fetchedEvents = eventsData.data;

        if (fetchError && fetchedEvents.count > 0)
        {
            [self logError:fetchError];
        }

        if (fetchedEvents.count > 0) {
            MGMEvent* event = [fetchedEvents objectAtIndex:0];
            NSManagedObjectID* moid = event.objectID;
            if ([self.eventMoid isEqual:moid] == NO)
            {
                self.eventMoid = moid;

                MGMPlaylistDto* playlist = nil;
//                if (event.spotifyPlaylistId)
//                {
//                    MGMDaoData* playlistData = [self.core.dao fetchAllEvents];
//                    if (playlistData.error)
//                    {
//                        [self logError:playlistData.error];
//                    }
//                    if (playlistData.data)
//                    {
//                        playlist = playlistData.data;
//                    }
//                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayEventWithMoid:self.eventMoid playlist:playlist];
                });
            }
        }
        else
        {
            [self showError:fetchError];
        }
    });
}

- (void) displayEventWithMoid:(NSManagedObjectID*)eventMoid playlist:(MGMPlaylistDto*)playlist
{
    MGMEvent* event = [self.core.coreDataAccess threadVersion:eventMoid];
    [self displayEvent:event playlist:playlist];
}

- (void) displayEvent:(MGMEvent*)event playlist:(MGMPlaylistDto*)playlist
{
    [super displayEvent:event playlist:playlist];

    MGMHomeView* homeView = (MGMHomeView*)self.view;
    [homeView setNextEventDate:event.eventDate];
}

@end
