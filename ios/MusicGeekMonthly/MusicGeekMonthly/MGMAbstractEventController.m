//
//  MGMAbstractEventController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventController.h"

@interface MGMAbstractEventController ()

@end

@implementation MGMAbstractEventController

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.classicAlbumView.alphaOff = 0;
    self.classicAlbumView.alphaOn = 1;
    self.classicAlbumView.animationTime = 0.25;
    self.classicAlbumView.pressable = NO;
    self.classicAlbumView.delegate = self;

    self.newlyReleasedAlbumView.alphaOff = 0;
    self.newlyReleasedAlbumView.alphaOn = 1;
    self.newlyReleasedAlbumView.animationTime = 0.25;
    self.newlyReleasedAlbumView.pressable = NO;
    self.newlyReleasedAlbumView.delegate = self;
}

- (void) displayEvent:(MGMEvent*)event
{
    self.event = event;

    self.classicAlbumView.activityInProgress = YES;
    self.newlyReleasedAlbumView.activityInProgress = YES;

    [self displayClassicAlbum:event.classicAlbum];
    [self displayNewRelease:event.newlyReleasedAlbum];
}

- (void) displayClassicAlbum:(MGMAlbum*)classicAlbum
{
    self.classicAlbumView.artistName = classicAlbum.artistName;
    self.classicAlbumView.albumName = classicAlbum.albumName;
    self.classicAlbumView.pressable = YES;
    self.classicAlbumView.detailViewShowing = YES;

    if ([classicAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            NSError* error = nil;
            [self.core.daoFactory.lastFmDao updateAlbumInfo:classicAlbum error:&error];
            if (error != nil)
            {
                [self handleError:error];
            }
            
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
    self.newlyReleasedAlbumView.pressable = YES;
    self.newlyReleasedAlbumView.detailViewShowing = YES;

    if ([newRelease searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            NSError* error = nil;
            [self.core.daoFactory.lastFmDao updateAlbumInfo:newRelease error:&error];
            if (error != nil)
            {
                [self handleError:error];
            }

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
    NSString* albumArtUri = [newRelease bestAlbumImageUrl];
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
                 self.newlyReleasedAlbumView.activityInProgress = NO;
                 [self.newlyReleasedAlbumView renderImage:image];
             }
         }];
    }
    else
    {
        self.newlyReleasedAlbumView.activityInProgress = NO;
        [self.newlyReleasedAlbumView renderImage:[UIImage imageNamed:@"album1.png"]];
    }
}

- (void) displayClassicAlbumImage:(MGMAlbum*)classicAlbum
{
    NSString* albumArtUri = [classicAlbum bestAlbumImageUrl];
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
                 self.classicAlbumView.activityInProgress = NO;
                 [self.classicAlbumView renderImage:image];
             }
         }];
    }
    else
    {
        self.classicAlbumView.activityInProgress = NO;
        [self.classicAlbumView renderImage:[UIImage imageNamed:@"album3.png"]];
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
