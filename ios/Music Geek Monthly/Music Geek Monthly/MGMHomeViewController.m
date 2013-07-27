
//
//  MGMHomeViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeViewController.h"
#import "MGMPulsatingAlbumsView.h"
#import "MGMEvent.h"

@interface MGMHomeViewController ()

@property (strong) IBOutlet MGMPulsatingAlbumsView* albumsView;
@property (strong) IBOutlet UIButton* classicAlbumButton;
@property (strong) IBOutlet UIButton* newlyReleasedAlbumButton;

- (IBAction) previousEventsPressed:(id)sender;
- (IBAction) chartsPressed:(id)sender;

@end

@implementation MGMHomeViewController

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
    }
    return self;
}

- (void) viewDidLoad
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        NSArray* events = [self.core.daoFactory.eventsDao events];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            MGMEvent* event = [events objectAtIndex:0];
            [self displayEvent:event];
            [self.albumsView setupAlbumsInRow:4];
        });
    });
}

- (void) viewDidAppear:(BOOL)animated
{
    [self loadImages];
}

- (void) displayEvent:(MGMEvent*)event
{
    [self displayClassicAlbum:event.classicAlbum];
    [self displayNewRelease:event.newlyReleasedAlbum];
}

- (void) displayClassicAlbum:(MGMAlbum*)classicAlbum
{
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
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
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
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage *image)
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

- (void) loadImages
{
    NSArray* albums = [self.core.daoFactory.lastFmDao topWeeklyAlbumsForMostRecentTimePeriod:30];
    NSMutableArray* images = [NSMutableArray arrayWithCapacity:albums.count];
    for (MGMGroupAlbum* album in albums)
    {
        NSString* albumArtUri = [self bestImageForAlbum:album];
        if (albumArtUri)
        {
            UIImage* image = [MGMImageHelper imageFromUrl:albumArtUri];
            if (image)
            {
                [images addObject:image];
            }
        }
    }

    [self.albumsView renderImages:images];
}

- (IBAction) previousEventsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionPreviousEvents];
}

- (IBAction) chartsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionCharts];
}

@end
