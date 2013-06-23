//
//  MGMPlaylistsViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlaylistsViewController.h"
#import "MGMSpotifyPlaylist.h"

@interface MGMPlaylistsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong) IBOutlet UITableView* eventsTable;
@property (strong) IBOutlet UIWebView* webView;

@property (strong) NSDateFormatter* dateFormatter;
@property (strong) NSArray* eventPlaylists;

@end

@implementation MGMPlaylistsViewController

#define CELL_ID @"MGMPlaylistsViewControllerCellId"

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

    self.eventsTable.dataSource = self;
    self.eventsTable.delegate = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.eventPlaylists = [self.core.daoFactory.spotifyDao eventPlaylists];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self.eventsTable reloadData];
            NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.eventsTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];

            MGMSpotifyPlaylist* playlist = [self.eventPlaylists objectAtIndex:0];
            [self loadPlaylist:playlist];
        });
    });
}

- (void) loadPlaylist:(MGMSpotifyPlaylist*)playlist
{
    NSURL* url = [NSURL URLWithString:playlist.httpUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventPlaylists.count;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }

    MGMSpotifyPlaylist* playlist = [self.eventPlaylists objectAtIndex:indexPath.row];
	NSString* dateString = [self.dateFormatter stringFromDate:playlist.eventDate];

    cell.textLabel.text = [NSString stringWithFormat:@"MGM%d %@", playlist.eventNumber, dateString];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMSpotifyPlaylist* playlist = [self.eventPlaylists objectAtIndex:indexPath.row];
    [self loadPlaylist:playlist];
}

- (void) openPlaylistInSpotify:(MGMSpotifyPlaylist*)playlist
{
    if (playlist.spotifyUrl)
    {
        NSURL* actualUrl = [NSURL URLWithString:playlist.spotifyUrl];
        [[UIApplication sharedApplication] openURL:actualUrl];
    }
    else
    {
        // Report a problem.
    }
}

@end
