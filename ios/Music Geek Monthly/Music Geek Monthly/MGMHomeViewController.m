
//
//  MGMHomeViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeViewController.h"
#import "MGMPulsatingAlbumsView.h"
#import "MGMAlbumView.h"
#import "MGMEvent.h"

@interface MGMHomeViewController () <MGMAlbumViewDelegate>

@property (strong) IBOutlet MGMPulsatingAlbumsView* albumsView;
@property (strong) IBOutlet MGMAlbumView* classicAlbumView;
@property (strong) IBOutlet MGMAlbumView* newlyReleasedAlbumView;

@property (strong) MGMEvent* event;
@property (strong) NSArray* backgroundImages;

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
    [super viewDidLoad];
    
    self.classicAlbumView.alphaOff = 0;
    self.classicAlbumView.alphaOn = 1;
    self.classicAlbumView.animationTime = 1;
    self.classicAlbumView.activityInProgress = YES;
    self.classicAlbumView.pressable = NO;
    self.classicAlbumView.delegate = self;

    self.newlyReleasedAlbumView.alphaOff = 0;
    self.newlyReleasedAlbumView.alphaOn = 1;
    self.newlyReleasedAlbumView.animationTime = 1;
    self.newlyReleasedAlbumView.activityInProgress = YES;
    self.newlyReleasedAlbumView.pressable = NO;
    self.newlyReleasedAlbumView.delegate = self;

    [self.albumsView setupAlbumsInRow:4];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.event = [self.core.daoFactory.eventsDao latestEvent];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self displayEvent:self.event];
        });
    });

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadImages];
}

- (void) displayEvent:(MGMEvent*)event
{
    [self displayClassicAlbum:event.classicAlbum];
    [self displayNewRelease:event.newlyReleasedAlbum];
}

- (void) displayClassicAlbum:(MGMAlbum*)classicAlbum
{
    if ([classicAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao updateAlbumInfo:classicAlbum];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                self.classicAlbumView.activityInProgress = NO;
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
    if ([newRelease searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao updateAlbumInfo:newRelease];
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                self.newlyReleasedAlbumView.activityInProgress = NO;
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
            self.newlyReleasedAlbumView.artistName = newRelease.artistName;
            self.newlyReleasedAlbumView.albumName = newRelease.albumName;
            self.newlyReleasedAlbumView.pressable = YES;
            self.newlyReleasedAlbumView.detailViewShowing = YES;
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
            self.classicAlbumView.artistName = classicAlbum.artistName;
            self.classicAlbumView.albumName = classicAlbum.albumName;
            self.classicAlbumView.pressable = YES;
            self.classicAlbumView.detailViewShowing = YES;
        }];
    }
}

- (NSString*) bestImageForAlbum:(MGMAlbum*)album
{
    // TODO - Make this a strategy
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

- (void) loadImages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        if (self.backgroundImages == nil)
        {
            self.backgroundImages = [self.core.daoFactory.lastFmDao topWeeklyAlbumsForMostRecentTimePeriod:30];
        }
        NSMutableArray* images = [NSMutableArray arrayWithCapacity:self.backgroundImages.count];
        for (MGMAlbum* album in self.backgroundImages)
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

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self.albumsView renderImages:images];
        });
    });
}

- (IBAction) previousEventsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionPreviousEvents];
}

- (IBAction) chartsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionCharts];
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
