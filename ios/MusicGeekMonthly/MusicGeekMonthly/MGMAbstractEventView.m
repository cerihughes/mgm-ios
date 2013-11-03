//
//  MGMAbstractEventView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventView.h"

@interface MGMAbstractEventView () <MGMAlbumViewDelegate>

@property (strong) MGMAlbumView* classicAlbumView;
@property (strong) MGMAlbumView* newlyReleasedAlbumView;

@end

@implementation MGMAbstractEventView

- (void) commonInit
{
    self.classicAlbumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
    self.classicAlbumView.alphaOn = 1;
    self.classicAlbumView.animationTime = 0.25;
    self.classicAlbumView.pressable = YES;
    self.classicAlbumView.delegate = self;
    self.classicAlbumView.detailViewShowing = YES;

    self.newlyReleasedAlbumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
    self.newlyReleasedAlbumView.alphaOn = 1;
    self.newlyReleasedAlbumView.animationTime = 0.25;
    self.newlyReleasedAlbumView.pressable = YES;
    self.newlyReleasedAlbumView.delegate = self;
    self.newlyReleasedAlbumView.detailViewShowing = YES;
}

#pragma mark -
#pragma mark MGMAlbumViewDelegate

- (void) albumPressed:(MGMAlbumView*)albumView
{
    if (albumView == self.classicAlbumView)
    {
        [self.delegate classicAlbumPressed];
    }
    else
    {
        [self.delegate newlyReleasedAlbumPressed];
    }
}

- (void) detailPressed:(MGMAlbumView*)albumView
{
    if (albumView == self.classicAlbumView)
    {
        [self.delegate classicAlbumDetailPressed];
    }
    else
    {
        [self.delegate newlyReleasedAlbumDetailPressed];
    }
}


@end
