//
//  MGMAbstractEventView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventView.h"

#import "MGMGridManager.h"

@interface MGMAbstractEventView () <MGMAlbumViewDelegate, MGMAlbumGridViewDelegate>

@property (strong) UILabel* classicAlbumLabel;
@property (strong) MGMAlbumView* classicAlbumView;
@property (strong) UILabel* newlyReleasedAlbumLabel;
@property (strong) MGMAlbumView* newlyReleasedAlbumView;
@property (strong) UILabel* playlistLabel;
@property (strong) MGMAlbumGridView* playlistView;
@property NSUInteger playlistViewRowCount;

@end

@implementation MGMAbstractEventView

- (void) commonInit
{
    [super commonInit];
    
    self.classicAlbumLabel = [MGMView italicTitleLabelWithText:@"Classic Album"];
    self.newlyReleasedAlbumLabel = [MGMView italicTitleLabelWithText:@"New Album"];
    self.playlistLabel = [MGMView italicTitleLabelWithText:@"Playlist"];

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

    self.playlistView = [[MGMAlbumGridView alloc] initWithFrame:CGRectZero];
    self.playlistView.delegate = self;
    self.playlistViewRowCount = self.screenSize == MGMViewScreenSizeiPad ? 5 : 3;
    [self.playlistView setAlbumCount:self.playlistViewRowCount * self.playlistViewRowCount];
}

- (void) updatePlaylistAlbumSizes
{
    // Resize the album view for new data...
    // TODO: This ultimately needs to bein the layoutSubviews method of the grid view...
    NSUInteger rowCount = self.playlistViewRowCount;
    NSUInteger albumCount = self.playlistViewRowCount * self.playlistViewRowCount;
    CGFloat albumSize = self.playlistView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:rowCount size:albumSize count:albumCount];

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
