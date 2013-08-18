//
//  MGMEventsViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsViewController.h"

#import "MGMCoreDataTableViewDataSource.h"
#import "MGMEvent.h"

@interface MGMEventsViewController () <UITableViewDelegate>

@property (strong) IBOutlet UITableView* eventsTable;
@property (strong) MGMCoreDataTableViewDataSource* dataSource;
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

    NSFetchedResultsController* fetchedResultsController = [self.core.daoFactory.coreDataDao createEventsFetchedResultsController];
    self.dataSource = [[MGMCoreDataTableViewDataSource alloc] initWithCellId:CELL_ID];
    self.dataSource.fetchedResultsController = fetchedResultsController;

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
#pragma mark UITableViewDataSource

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    MGMEvent* event = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];

    MGMAlbum* classicAlbum = event.classicAlbum;
    if ([classicAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        [self.core.daoFactory.lastFmDao updateAlbumInfo:classicAlbum completion:^(MGMAlbum* updatedAlbum, NSError* updateError)
        {
            if (updateError != nil)
            {
                [self handleError:updateError];
            }

            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                [self addAlbumImage:updatedAlbum toCell:cell];
            });
        }];
    }
    else
    {
        [self addAlbumImage:classicAlbum toCell:cell];
    }
    return cell;
}

- (void) addAlbumImage:(MGMAlbum*)album toCell:(UITableViewCell*)cell
{
    NSString* albumArtUri = [album bestTableImageUrl];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage* image, NSError* error)
        {
            if (error)
            {
                [self handleError:error];
            }
            else
            {
                cell.imageView.image = image;
            }
        }];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"album1.png"];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMEvent* event = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    [self displayEvent:event];
}

@end
