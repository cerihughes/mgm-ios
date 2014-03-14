//
//  MGMEventsViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsViewController.h"

#import "MGMEvent.h"
#import "MGMEventsView.h"
#import "MGMEventsModalView.h"
#import "MGMEventTableViewDataSource.h"

@interface MGMEventsViewController () <UITableViewDelegate, MGMEventsViewDelegate, MGMEventsModalViewDelegate>

@property (strong) MGMEventsModalView* modalView;
@property (strong) MGMEventTableViewDataSource* dataSource;

@end

@implementation MGMEventsViewController

#define CELL_ID @"MGMEventsViewControllerCellId"

#define EVENT_TITLE_PATTERN @"MGM#%@ %@"

- (void) loadView
{
    MGMEventsView* eventsView = [[MGMEventsView alloc] initWithFrame:[self fullscreenRect]];
    eventsView.classicAlbumView.animationTime = 0.25;
    eventsView.newlyReleasedAlbumView.animationTime = 0.25;
    eventsView.delegate = self;

    self.dataSource = [[MGMEventTableViewDataSource alloc] initWithCellId:CELL_ID];
    self.dataSource.coreDataAccess = self.core.coreDataAccess;
    self.dataSource.albumRenderService = self.core.albumRenderService;
    self.dataSource.imageHelper = self.ui.imageHelper;

    self.modalView = [[MGMEventsModalView alloc] initWithFrame:[self fullscreenRect]];
    self.modalView.eventsTable.dataSource = self.dataSource;
    self.modalView.eventsTable.delegate = self;
    self.modalView.delegate = self;

    self.view = eventsView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.core.dao fetchAllEvents:^(MGMDaoData* eventData) {
        if (eventData.error)
        {
            [self showError:eventData.error];
        }
        else
        {
            NSArray* moids = eventData.data;
            NSArray* renderables = [self.core.coreDataAccess mainThreadVersions:moids];
            [self.dataSource setRenderables:renderables];
            
            [self.modalView.eventsTable reloadData];
            
            if (self.event == nil && renderables.count > 0)
            {
                // Auto-populate for 1st entry...
                NSIndexPath* firstItem = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.modalView.eventsTable selectRowAtIndexPath:firstItem animated:YES scrollPosition:UITableViewScrollPositionTop];
                [self tableView:self.modalView.eventsTable didSelectRowAtIndexPath:firstItem];
            }
        }
    }];
}

- (void) displayEvent:(MGMEvent*)event
{
    MGMEventsView* eventsView = (MGMEventsView*)self.view;

	NSString* dateString = event.groupValue;
    NSString* newTitle = [NSString stringWithFormat:EVENT_TITLE_PATTERN, event.eventNumber, dateString];
    [eventsView setTitle:newTitle];

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
                NSManagedObjectID* moid = playlistData.data;
                MGMPlaylist* playlist = [self.core.coreDataAccess mainThreadVersion:moid];
                [self displayEvent:event playlist:playlist];
            }
            else
            {
                [self displayEvent:event playlist:nil];
            }
        }];
    }
    else
    {
        [super displayEvent:event playlist:nil];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self dismissModalPresentation];
    MGMEvent* event = [self.dataSource objectAtIndexPath:indexPath];
    [self displayEvent:event];
}

#pragma mark -
#pragma mark MGMEventsViewDelegate

- (void) moreButtonPressed:(id)sender
{
    if ([self isPresentingModally])
    {
        [self dismissModalPresentation];
    }
    else
    {
        [self presentViewModally:self.modalView sender:sender];
    }
}

#pragma mark -
#pragma mark MGMEventsModalViewDelegate

- (void) cancelButtonPressed:(id)sender
{
    [self moreButtonPressed:sender];
}

@end
