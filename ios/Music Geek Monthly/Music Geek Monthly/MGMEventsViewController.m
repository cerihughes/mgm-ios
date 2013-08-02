//
//  MGMEventsViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsViewController.h"
#import "MGMEvent.h"
#import "MGMAlbumView.h"

@interface MGMEventsViewController () <UITableViewDataSource, UITableViewDelegate, MGMAlbumViewDelegate>

@property (strong) IBOutlet UITableView* eventsTable;
@property (strong) IBOutlet MGMAlbumView* classicAlbumView;
@property (strong) IBOutlet MGMAlbumView* newlyReleasedAlbumView;
@property (strong) IBOutlet UIWebView* playlistWebView;

@property (strong) NSDateFormatter* dateFormatter;
@property (strong) NSArray* events;
@property (strong) MGMEvent* event;

@end

@implementation MGMEventsViewController

#define CELL_ID @"MGMEventsViewControllerCellId"

#define EVENT_TITLE_PATTERN @"MGM#%d %@"
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

    self.classicAlbumView.alphaOff = 0;
    self.classicAlbumView.alphaOn = 1;
    self.classicAlbumView.animationTime = 0.25;
    self.classicAlbumView.activityInProgress = YES;
    self.classicAlbumView.pressable = NO;
    self.classicAlbumView.delegate = self;

    self.newlyReleasedAlbumView.alphaOff = 0;
    self.newlyReleasedAlbumView.alphaOn = 1;
    self.newlyReleasedAlbumView.animationTime = 0.25;
    self.newlyReleasedAlbumView.activityInProgress = YES;
    self.newlyReleasedAlbumView.pressable = NO;
    self.newlyReleasedAlbumView.delegate = self;

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
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.eventsTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];

            MGMEvent* event = [self.events objectAtIndex:0];
            [self displayEvent:event];
        });
    });
}

- (void) displayEvent:(MGMEvent*)event
{
    self.event = event;
    
	NSString* dateString = [self.dateFormatter stringFromDate:event.eventDate];
    self.title = [NSString stringWithFormat:EVENT_TITLE_PATTERN, event.eventNumber, dateString];

    NSString* urlString = [NSString stringWithFormat:WEB_URL_PATTERN, event.spotifyHttpUrl];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.playlistWebView loadRequest:request];

    [self displayClassicAlbum:event.classicAlbum];
    [self displayNewRelease:event.newlyReleasedAlbum];
}

- (void) displayClassicAlbum:(MGMAlbum*)classicAlbum
{
    self.classicAlbumView.artistName = classicAlbum.artistName;
    self.classicAlbumView.albumName = classicAlbum.albumName;

    if ([classicAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao updateAlbumInfo:classicAlbum];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                [self displayClassicAlbumImage:classicAlbum];
            });
        });
    }
    else
    {
        [self displayClassicAlbumImage:classicAlbum];
    }
}
- (void) displayNewRelease:(MGMAlbum*)newRelease
{
    self.newlyReleasedAlbumView.artistName = newRelease.artistName;
    self.newlyReleasedAlbumView.albumName = newRelease.albumName;

    if ([newRelease searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao updateAlbumInfo:newRelease];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                [self displayNewReleaseAlbumImage:newRelease];
            });
        });
    }
    else
    {
        [self displayNewReleaseAlbumImage:newRelease];
    }
}

- (void) displayNewReleaseAlbumImage:(MGMAlbum*)newRelease
{
    NSString* albumArtUri = [self bestImageForAlbum:newRelease];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
        {
            [self.newlyReleasedAlbumView renderImage:image];
        }];
    }
}

- (void) displayClassicAlbumImage:(MGMAlbum*)classicAlbum
{
    NSString* albumArtUri = [self bestImageForAlbum:classicAlbum];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
        {
            [self.classicAlbumView renderImage:image];
        }];
    }
}

- (NSString*) bestImageForAlbum:(MGMAlbum*)album
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSizeExtraLarge, MGMAlbumImageSizeMega, MGMAlbumImageSizeLarge, MGMAlbumImageSizeMedium, MGMAlbumImageSizeSmall};
    for (NSUInteger i = 0; i < 5; i++)
    {
        NSString* uri = [album imageUrlForImageSize:sizes[i]];
        if (uri)
        {
            return uri;
        }
    }
    return nil;
}

- (MGMEvent*) selectedEvent
{
    NSIndexPath* indexPath = [[self.eventsTable indexPathsForSelectedRows] objectAtIndex:0];
    return [self.events objectAtIndex:indexPath.row];
}

- (MGMAlbum*) selectedClassicAlbum
{
    return self.selectedEvent.classicAlbum;
}

- (MGMAlbum*) selectedNewlyReleasedAlbum
{
    return self.selectedEvent.newlyReleasedAlbum;
}

- (void) navigateToWebPanel:(NSString*)uri
{
    [self.ui transition:TO_WEB withState:uri];
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
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMEvent* event = [self.events objectAtIndex:indexPath.row];
    [self displayEvent:event];
}

- (void) openEventPlaylistInSpotify:(MGMEvent*)event
{
    if (event.spotifyPlaylistUrl)
    {
        NSURL* actualUrl = [NSURL URLWithString:event.spotifyPlaylistUrl];
        [[UIApplication sharedApplication] openURL:actualUrl];
    }
    else
    {
        // Report a problem.
    }
}

#pragma mark -
#pragma mark MGMAlbumViewDelegate

- (MGMAlbum*) albumForAlbumView:(MGMAlbumView*)albumView
{
    return albumView == self.classicAlbumView ? self.event.classicAlbum : self.event.newlyReleasedAlbum;
}

- (void) albumPressed:(MGMAlbumView*)albumView
{
    [self.albumSelectionDelegate albumSelected:[self albumForAlbumView:albumView]];
}

- (void) detailPressed:(MGMAlbumView*)albumView
{
    [self.albumSelectionDelegate detailSelected:[self albumForAlbumView:albumView]];
}

@end
