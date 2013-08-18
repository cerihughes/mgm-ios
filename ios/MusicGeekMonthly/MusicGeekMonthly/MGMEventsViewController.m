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

@property (strong) IBOutlet UITableView* eventsTable;
@property (strong) MGMEventTableViewDataSource* dataSource;
@property (strong) IBOutlet UIWebView* playlistWebView;
@property (strong) IBOutlet UIViewController* iPhone2ndController;

@end

@implementation MGMEventsViewController

#define CELL_ID @"MGMEventsViewControllerCellId"

#define EVENT_TITLE_PATTERN @"MGM#%@ %@"
#define WEB_URL_PATTERN @"https://embed.spotify.com/?uri=%@"

- (void) viewDidLoad
{
    [super viewDidLoad];

    UINib* tableCellNib = [UINib nibWithNibName:@"MGMEventTableCell" bundle:nil];
    [self.eventsTable registerNib:tableCellNib forCellReuseIdentifier:CELL_ID];

    NSFetchedResultsController* fetchedResultsController = [self.core.daoFactory.coreDataDao createEventsFetchedResultsController];
    self.dataSource = [[MGMEventTableViewDataSource alloc] initWithCellId:CELL_ID];
    self.dataSource.fetchedResultsController = fetchedResultsController;
    self.dataSource.lastFmDao = self.core.daoFactory.lastFmDao;

    self.eventsTable.dataSource = self.dataSource;
    self.eventsTable.delegate = self;

    NSError* error = nil;
    [fetchedResultsController performFetch:&error];
    if (error != nil)
    {
        [self handleError:error];
    }

    [self.eventsTable reloadData];

    self.classicAlbumView.animationTime = 0.25;
    self.newlyReleasedAlbumView.animationTime = 0.25;

    if (self.iPhone2ndController == nil)
    {
        // Only auto-populate on iPad...
        NSIndexPath* firstItem = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.eventsTable selectRowAtIndexPath:firstItem animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.eventsTable didSelectRowAtIndexPath:firstItem];
    }
}

- (void) displayEvent:(MGMEvent*)event
{
    [super displayEvent:event];

	NSString* dateString = event.groupValue;
    NSString* newTitle = [NSString stringWithFormat:EVENT_TITLE_PATTERN, event.eventNumber, dateString];

    if (self.iPhone2ndController)
    {
        [self.navigationController pushViewController:self.iPhone2ndController animated:YES];
        self.iPhone2ndController.title = newTitle;
    }
    else
    {
        self.title = newTitle;
    }

    NSString* urlString = [NSString stringWithFormat:WEB_URL_PATTERN, event.spotifyHttpUrl];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.playlistWebView loadRequest:request];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMEvent* event = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    [self displayEvent:event];
}

@end
