//
//  MGMEventsViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsViewController.h"

#import "MGMEventTableViewDataSource.h"
#import "MGMEvent.h"

@interface MGMEventsViewController () <UITableViewDelegate>

@property (strong) IBOutlet UINavigationItem* eventNavigationItem;
@property (strong) IBOutlet UITableView* eventsTable;
@property (strong) IBOutlet UIView* modalView;
@property (strong) IBOutlet UIWebView* playlistWebView;

@property (strong) MGMEventTableViewDataSource* dataSource;

@end

@implementation MGMEventsViewController

#define CELL_ID @"MGMEventsViewControllerCellId"

#define EVENT_TITLE_PATTERN @"MGM#%@ %@"
#define WEB_URL_PATTERN @"https://embed.spotify.com/?uri=%@"

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
    }
    return self;
}

- (IBAction) barButtonPressed:(id)sender
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

- (void) viewDidLoad
{
    [super viewDidLoad];

    UINib* tableCellNib = [UINib nibWithNibName:@"MGMEventTableCell" bundle:nil];
    [self.eventsTable registerNib:tableCellNib forCellReuseIdentifier:CELL_ID];

    NSFetchedResultsController* fetchedResultsController = [self.core.daoFactory.coreDataDao createEventsFetchedResultsController];
    self.dataSource = [[MGMEventTableViewDataSource alloc] initWithCellId:CELL_ID];
    self.dataSource.fetchedResultsController = fetchedResultsController;
    self.dataSource.daoFactory = self.core.daoFactory;

    self.eventsTable.dataSource = self.dataSource;
    self.eventsTable.delegate = self;

    NSError* error = nil;
    [fetchedResultsController performFetch:&error];
    if (error != nil)
    {
        [self showError:error];
    }

    [self.eventsTable reloadData];

    // TODO: put this back
//    self.classicAlbumView.animationTime = 0.25;
//    self.newlyReleasedAlbumView.animationTime = 0.25;

    // Auto-populate for 1st entry...
    NSIndexPath* firstItem = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.eventsTable selectRowAtIndexPath:firstItem animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.eventsTable didSelectRowAtIndexPath:firstItem];
}

- (void) displayEvent:(MGMEvent*)event
{
    [super displayEvent:event];

	NSString* dateString = event.groupValue;
    NSString* newTitle = [NSString stringWithFormat:EVENT_TITLE_PATTERN, event.eventNumber, dateString];
    self.eventNavigationItem.title = newTitle;

    NSString* urlString = [NSString stringWithFormat:WEB_URL_PATTERN, event.spotifyHttpUrl];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.playlistWebView loadRequest:request];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self dismissModalPresentation];
    MGMEvent* event = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    [self displayEvent:event];
}

@end
