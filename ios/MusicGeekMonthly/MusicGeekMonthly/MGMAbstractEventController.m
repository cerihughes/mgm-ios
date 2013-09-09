//
//  MGMAbstractEventController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventController.h"

#import "MGMAlbumViewUtilities.h"

@interface MGMAbstractEventController ()

@end

@implementation MGMAbstractEventController

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.classicAlbumView.alphaOn = 1;
    self.classicAlbumView.animationTime = 0.25;
    self.classicAlbumView.pressable = YES;
    self.classicAlbumView.delegate = self;
    self.classicAlbumView.detailViewShowing = YES;

    self.newlyReleasedAlbumView.alphaOn = 1;
    self.newlyReleasedAlbumView.animationTime = 0.25;
    self.newlyReleasedAlbumView.pressable = YES;
    self.newlyReleasedAlbumView.delegate = self;
    self.newlyReleasedAlbumView.detailViewShowing = YES;
}

- (void) displayEvent:(MGMEvent*)event
{
    self.event = event;

    NSError* error1 = nil;
    [MGMAlbumViewUtilities displayAlbum:event.classicAlbum inAlbumView:self.classicAlbumView defaultImageName:@"album3.png" daoFactory:self.core.daoFactory error:&error1];
    if (error1)
    {
        [self logError:error1];
    }
    
    NSError* error2 = nil;
    [MGMAlbumViewUtilities displayAlbum:event.newlyReleasedAlbum inAlbumView:self.newlyReleasedAlbumView defaultImageName:@"album1.png" daoFactory:self.core.daoFactory error:&error2];
    if (error2)
    {
        [self logError:error2];
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
    [self.albumSelectionDelegate detailSelected:[self albumForAlbumView:albumView] sender:self];
}

@end
