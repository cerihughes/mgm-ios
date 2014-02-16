//
//  MGMAbstractEventViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventViewController.h"

#import "MGMAbstractEventView.h"
#import "MGMAlbumViewUtilities.h"

@interface MGMAbstractEventViewController () <MGMAbstractEventViewDelegate>

@end

@implementation MGMAbstractEventViewController

- (void) displayEvent:(MGMEvent*)event
{
    self.event = event;

    MGMAbstractEventView* eventView = (MGMAbstractEventView*)self.view;

    NSError* error1 = nil;
    [MGMAlbumViewUtilities displayAlbum:event.classicAlbum inAlbumView:eventView.classicAlbumView defaultImageName:@"album3.png" renderService:self.core.albumRenderService error:&error1];
    if (error1)
    {
        [self logError:error1];
    }
    
    NSError* error2 = nil;
    [MGMAlbumViewUtilities displayAlbum:event.newlyReleasedAlbum inAlbumView:eventView.newlyReleasedAlbumView defaultImageName:@"album1.png" renderService:self.core.albumRenderService error:&error2];
    if (error2)
    {
        [self logError:error2];
    }
}

#pragma mark -
#pragma mark MGMAbstractEventViewDelegate

- (void) classicAlbumPressed
{
    [self.albumSelectionDelegate albumSelected:self.event.classicAlbum];
}

- (void) classicAlbumDetailPressed
{
    [self.albumSelectionDelegate detailSelected:self.event.classicAlbum sender:self];
}

- (void) newlyReleasedAlbumPressed
{
    [self.albumSelectionDelegate albumSelected:self.event.newlyReleasedAlbum];
}

- (void) newlyReleasedAlbumDetailPressed
{
    [self.albumSelectionDelegate detailSelected:self.event.newlyReleasedAlbum sender:self];
}

@end
