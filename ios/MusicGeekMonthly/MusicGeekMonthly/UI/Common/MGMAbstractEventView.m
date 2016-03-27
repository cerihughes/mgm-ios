//
//  MGMAbstractEventView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventView.h"

#import "MGMAlbumGridView.h"
#import "MGMAlbumView.h"
#import "MGMGridManager.h"

@interface MGMAbstractEventView () <MGMAlbumViewDelegate, MGMAlbumGridViewDelegate>

@end

@implementation MGMAbstractEventView

- (void) commonInit
{
    [super commonInit];
    
    _classicAlbumLabel = [MGMView italicTitleLabelWithText:@"Classic Album"];
    _newlyReleasedAlbumLabel = [MGMView italicTitleLabelWithText:@"New Album"];
    _playlistLabel = [MGMView italicTitleLabelWithText:@"Playlist"];

    _classicAlbumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
    _classicAlbumView.translatesAutoresizingMaskIntoConstraints = NO;
    _classicAlbumView.alphaOn = 1;
    _classicAlbumView.animationTime = 0.25;
    _classicAlbumView.pressable = YES;
    _classicAlbumView.delegate = self;
    _classicAlbumView.detailViewShowing = YES;

    _newlyReleasedAlbumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
    _newlyReleasedAlbumView.translatesAutoresizingMaskIntoConstraints = NO;
    _newlyReleasedAlbumView.alphaOn = 1;
    _newlyReleasedAlbumView.animationTime = 0.25;
    _newlyReleasedAlbumView.pressable = YES;
    _newlyReleasedAlbumView.delegate = self;
    _newlyReleasedAlbumView.detailViewShowing = YES;

    _playlistViewRowCount = mgm_isIpad() ? 5 : 3;

    _playlistView = [[MGMAlbumGridView alloc] initWithFrame:CGRectZero];
    _playlistView.translatesAutoresizingMaskIntoConstraints = NO;
    _playlistView.delegate = self;
    [_playlistView setAlbumCount:_playlistViewRowCount * _playlistViewRowCount detailViewShowing:NO];
}

- (void) updatePlaylistAlbumSizes
{
    // Resize the album view for new data...
    // TODO: This ultimately needs to bein the layoutSubviews method of the grid view...
    NSUInteger rowCount = self.playlistViewRowCount;
    NSUInteger albumCount = self.playlistViewRowCount * self.playlistViewRowCount;
    CGFloat albumSize = self.playlistView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRowSize:rowCount defaultRectSize:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [self.playlistView setAlbumFrame:frame forRank:i + 1];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    [self updatePlaylistAlbumSizes];
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

#pragma mark -
#pragma mark MGMAlbumGridViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    [self.delegate playlistPressed];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    [self.delegate playlistPressed];
}

@end
