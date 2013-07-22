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
@property (strong) IBOutlet UILabel* classicAlbumArtistLabel;
@property (strong) IBOutlet UILabel* classicAlbumTitleLabel;
@property (strong) IBOutlet UIButton* classicAlbumButton;
@property (strong) IBOutlet UILabel* newlyReleasedAlbumArtistLabel;
@property (strong) IBOutlet UILabel* newlyReleasedAlbumTitleLabel;
@property (strong) IBOutlet UIButton* newlyReleasedAlbumButton;
@property (strong) IBOutlet UIWebView* playlistWebView;

@property (strong) IBOutlet UIButton* classicAlbumSpotifyButton;
@property (strong) IBOutlet UIButton* classicAlbumLastFmButton;
@property (strong) IBOutlet UIButton* classicAlbumWikipediaButton;
@property (strong) IBOutlet UIButton* classicAlbumYouTubeButton;
@property (strong) IBOutlet UIButton* newlyReleasedAlbumSpotifyButton;
@property (strong) IBOutlet UIButton* newlyReleasedAlbumLastFmButton;
@property (strong) IBOutlet UIButton* newlyReleasedAlbumWikipediaButton;
@property (strong) IBOutlet UIButton* newlyReleasedAlbumYouTubeButton;

@property (strong) NSDateFormatter* dateFormatter;
@property (strong) NSArray* events;

- (IBAction)classicAlbumLastFmPressed:(id)sender;
- (IBAction)classicAlbumSpotifyPressed:(id)sender;
- (IBAction)classicAlbumWikipediaPressed:(id)sender;
- (IBAction)classicAlbumYouTubePressed:(id)sender;
- (IBAction)newlyReleasedAlbumLastFmPressed:(id)sender;
- (IBAction)newlyReleasedAlbumSpotifyPressed:(id)sender;
- (IBAction)newlyReleasedAlbumWikipediaPressed:(id)sender;
- (IBAction)newlyReleasedAlbumYouTubePressed:(id)sender;

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
    // Clear the album images...
    [self.classicAlbumButton setImage:[UIImage imageNamed:@"album1.png"] forState:UIControlStateNormal];
    [self.newlyReleasedAlbumButton setImage:[UIImage imageNamed:@"album2.png"] forState:UIControlStateNormal];

	NSString* dateString = [self.dateFormatter stringFromDate:event.eventDate];
    self.title = [NSString stringWithFormat:EVENT_TITLE_PATTERN, event.eventNumber, dateString];

    NSString* urlString = [NSString stringWithFormat:WEB_URL_PATTERN, event.spotifyHttpUrl];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.playlistWebView loadRequest:request];

    [self displayClassicAlbum:event.classicAlbum];
    [self displayNewRelease:event.newlyReleasedAlbum];
}

- (void) displayClassicAlbum:(MGMAlbum*)classicAlbum
{
    self.classicAlbumArtistLabel.text = classicAlbum.artistName;
    self.classicAlbumTitleLabel.text = classicAlbum.albumName;

    self.classicAlbumLastFmButton.hidden = (classicAlbum.lastFmUri == nil);
    self.classicAlbumSpotifyButton.hidden = (classicAlbum.spotifyUri == nil);
    self.classicAlbumWikipediaButton.hidden = (classicAlbum.wikipediaUri == nil);
    self.classicAlbumYouTubeButton.hidden = (classicAlbum.youTubeUri == nil);

    if (classicAlbum.searchedLastFmData == NO)
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
    self.newlyReleasedAlbumArtistLabel.text = newRelease.artistName;
    self.newlyReleasedAlbumTitleLabel.text = newRelease.albumName;

    self.newlyReleasedAlbumLastFmButton.hidden = (newRelease.lastFmUri == nil);
    self.newlyReleasedAlbumSpotifyButton.hidden = (newRelease.spotifyUri == nil);
    self.newlyReleasedAlbumWikipediaButton.hidden = (newRelease.wikipediaUri == nil);
    self.newlyReleasedAlbumYouTubeButton.hidden = (newRelease.youTubeUri == nil);

    if (newRelease.searchedLastFmData == NO)
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
        [self.ui.imageCache asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
        {
             [self.newlyReleasedAlbumButton setImage:image forState:UIControlStateNormal];
        }];
    }
}

- (void) displayClassicAlbumImage:(MGMAlbum*)classicAlbum
{
    NSString* albumArtUri = [self bestImageForAlbum:classicAlbum];
    if (albumArtUri)
    {
        [self.ui.imageCache asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
        {
            [self.classicAlbumButton setImage:image forState:UIControlStateNormal];
        }];
    }
}

- (NSString*) bestImageForAlbum:(MGMAlbum*)album
{
    NSString* uri;
    if((uri = [self imageSize:IMAGE_SIZE_EXTRA_LARGE forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_MEGA forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_LARGE forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_MEDIUM forAlbum:album]) != nil)
    {
        return uri;
    }
    if((uri = [self imageSize:IMAGE_SIZE_SMALL forAlbum:album]) != nil)
    {
        return uri;
    }
    return nil;
}

- (NSString*) imageSize:(NSString*)size forAlbum:(MGMAlbum*)album
{
    return [album.imageUris objectForKey:size];
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

- (IBAction)classicAlbumLastFmPressed:(id)sender
{
}

- (IBAction)classicAlbumSpotifyPressed:(id)sender
{
}

- (IBAction)classicAlbumWikipediaPressed:(id)sender
{
    [self navigateToWebPanel:self.selectedClassicAlbum.wikipediaUri];
}

- (IBAction)classicAlbumYouTubePressed:(id)sender
{
    [self navigateToWebPanel:self.selectedClassicAlbum.youTubeUri];
}

- (IBAction)newlyReleasedAlbumLastFmPressed:(id)sender
{

}

- (IBAction)newlyReleasedAlbumSpotifyPressed:(id)sender
{

}

- (IBAction)newlyReleasedAlbumWikipediaPressed:(id)sender
{
    [self navigateToWebPanel:self.selectedNewlyReleasedAlbum.wikipediaUri];
}

- (IBAction)newlyReleasedAlbumYouTubePressed:(id)sender
{
    [self navigateToWebPanel:self.selectedNewlyReleasedAlbum.youTubeUri];
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

@end
