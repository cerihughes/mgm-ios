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

@property (strong) UIView* modalView;
@property (strong) MGMEventTableViewDataSource* dataSource;

@end

@implementation MGMEventsViewController

#define CELL_ID @"MGMEventsViewControllerCellId"

#define EVENT_TITLE_PATTERN @"MGM#%@ %@"
#define WEB_URL_PATTERN @"https://embed.spotify.com/?uri=%@"

- (MGMEventsModalView*) loadModalView
{
    MGMEventsModalView* modalView = [[MGMEventsModalView alloc] initWithFrame:[self fullscreenRect]];
    
    NSFetchedResultsController* fetchedResultsController = [self.core.coreDataAccess createEventsFetchedResultsController];
    self.dataSource = [[MGMEventTableViewDataSource alloc] initWithCellId:CELL_ID];
    self.dataSource.fetchedResultsController = fetchedResultsController;
    self.dataSource.coreDataAccess = self.core.coreDataAccess;
    self.dataSource.albumRenderService = self.core.albumRenderService;
    
    modalView.eventsTable.dataSource = self.dataSource;
    modalView.eventsTable.delegate = self;
    
    NSError* error = nil;
    [fetchedResultsController performFetch:&error];
    if (error != nil)
    {
        [self showError:error];
    }
    
    [modalView.eventsTable reloadData];
    
    // Auto-populate for 1st entry...
    NSIndexPath* firstItem = [NSIndexPath indexPathForItem:0 inSection:0];
    [modalView.eventsTable selectRowAtIndexPath:firstItem animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:modalView.eventsTable didSelectRowAtIndexPath:firstItem];
    
    modalView.delegate = self;

    return modalView;
}

- (void) loadView
{
    MGMEventsView* eventsView = [[MGMEventsView alloc] initWithFrame:[self fullscreenRect]];
    eventsView.classicAlbumView.animationTime = 0.25;
    eventsView.newlyReleasedAlbumView.animationTime = 0.25;
    
    eventsView.delegate = self;
    self.view = eventsView;
    self.modalView = [self loadModalView];
}

- (void) displayEvent:(MGMEvent*)event
{
    [super displayEvent:event];

    MGMEventsView* eventsView = (MGMEventsView*)self.view;

	NSString* dateString = event.groupValue;
    NSString* newTitle = [NSString stringWithFormat:EVENT_TITLE_PATTERN, event.eventNumber, dateString];
    [eventsView setTitle:newTitle];

    NSString* urlString = nil;
    if (event.spotifyHttpUrl)
    {
        urlString = [NSString stringWithFormat:WEB_URL_PATTERN, event.spotifyHttpUrl];
    }
    [eventsView setPlaylistUrl:urlString];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self dismissModalPresentation];
    MGMEvent* event = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
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
