//
//  MGMEventsViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsViewController.h"
#import "MGMEvent.h"

@interface MGMEventsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong) IBOutlet UITableView* eventsTable;
@property (strong) IBOutlet UIWebView* playlistWebView;
@property (strong) IBOutlet UIViewController* iPhone2ndController;

@property (strong) NSDateFormatter* dateFormatter;
@property (strong) NSArray* events;

@end

@implementation MGMEventsViewController

#define CELL_ID @"MGMEventsViewControllerCellId"

#define EVENT_TITLE_PATTERN @"MGM#%@ %@"
#define WEB_URL_PATTERN @"https://embed.spotify.com/?uri=%@"

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        // MMM yyyy
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"MMM yyyy";
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.classicAlbumView.animationTime = 0.25;
    self.newlyReleasedAlbumView.animationTime = 0.25;

    self.eventsTable.dataSource = self;
    self.eventsTable.delegate = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.events = [self.core.daoFactory.eventsDao events];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self.eventsTable reloadData];
            
            if (self.iPhone2ndController == nil)
            {
                // Only auto-populate on iPad...
                NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.eventsTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];

                MGMEvent* event = [self.events objectAtIndex:0];
                [self displayEvent:event];
            }
        });
    });
}

- (void) displayEvent:(MGMEvent*)event
{
    [super displayEvent:event];
    
	NSString* dateString = [self.dateFormatter stringFromDate:event.eventDate];
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

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }

    MGMEvent* event = [self.events objectAtIndex:indexPath.row];
	NSString* dateString = [self.dateFormatter stringFromDate:event.eventDate];

    cell.textLabel.text = dateString;

    if ([event.classicAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao updateAlbumInfo:event.classicAlbum];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                [self addAlbumImage:event.classicAlbum toCell:cell];
            });
        });
    }
    else
    {
        [self addAlbumImage:event.classicAlbum toCell:cell];
    }
    return cell;
}

- (void) addAlbumImage:(MGMAlbum*)album toCell:(UITableViewCell*)cell
{
    NSString* albumArtUri = [album bestTableImageUrl];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
        {
            cell.imageView.image = image;
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
    MGMEvent* event = [self.events objectAtIndex:indexPath.row];
    [self displayEvent:event];
}

@end
