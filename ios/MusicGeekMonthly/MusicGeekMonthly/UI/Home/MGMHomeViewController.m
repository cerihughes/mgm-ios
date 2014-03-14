
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.core.dao fetchAllEvents:^(MGMDaoData* eventsData) {
        NSError* fetchError = eventsData.error;
        NSArray* fetchedEventMoids = eventsData.data;
        
        if (fetchError && fetchedEventMoids.count > 0)
        {
            [self logError:fetchError];
        }
        
        if (fetchedEventMoids.count > 0) {
            NSManagedObjectID* fetchedEventMoid = [fetchedEventMoids objectAtIndex:0];
            if ([self.eventMoid isEqual:fetchedEventMoid] == NO)
            {
                self.eventMoid = fetchedEventMoid;
                
                MGMEvent* event = [self.core.coreDataAccess mainThreadVersion:fetchedEventMoid];
                NSString* playlistId = event.playlistId;
                if (playlistId)
                {
                    [self.core.dao fetchPlaylist:playlistId completion:^(MGMDaoData* playlistData) {
                        if (playlistData.error)
                        {
                            [self logError:playlistData.error];
                        }
                        if (playlistData.data)
                        {
                            NSManagedObjectID* playlistMoid = playlistData.data;
                            MGMPlaylist* playlist = [self.core.coreDataAccess mainThreadVersion:playlistMoid];
                            [self displayEventWithMoid:self.eventMoid playlist:playlist];
                        }
                        else
                        {
                            [self displayEventWithMoid:self.eventMoid playlist:nil];                            
                        }
                    }];
                }
                else
                {
                    [self displayEventWithMoid:self.eventMoid playlist:nil];
                }
            }
        }
        else
        {
            [self showError:fetchError];
        }
    }];
}

- (void) displayEventWithMoid:(NSManagedObjectID*)eventMoid playlist:(MGMPlaylist*)playlist
{
    MGMEvent* event = [self.core.coreDataAccess mainThreadVersion:eventMoid];
    [self displayEvent:event playlist:playlist];
}

- (void) displayEvent:(MGMEvent*)event playlist:(MGMPlaylist*)playlist
{
    [super displayEvent:event playlist:playlist];

    MGMHomeView* homeView = (MGMHomeView*)self.view;
    [homeView setNextEventDate:event.eventDate];
}

@end
