//
//  MGMAlbumsView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 17/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumsView.h"
#import "MGMRankedAlbumView.h"

@interface MGMAlbumsView () <MGMPressableAlbumViewDelegate>

@property (strong) UIScrollView* scrollView;

@property (strong) NSMutableArray* albumViews;

@end

@implementation MGMAlbumsView

- (void) commonInit
{
    [super commonInit];

    CGSize parentSize = self.frame.size;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, parentSize.width, parentSize.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.scrollView];

    self.albumViews = [NSMutableArray arrayWithCapacity:15];
}

- (void) setupAlbumFrame:(CGRect)frame forRank:(NSUInteger)rank
{
    MGMRankedAlbumView* albumView = [[MGMRankedAlbumView alloc] initWithFrame:frame];
    albumView.alphaOn = 1;
    albumView.alphaOff = 0;
    albumView.animationTime = 0.5;
    albumView.rank = rank;
    albumView.delegate = self;
    [self.scrollView addSubview:albumView];
    [self.albumViews addObject:albumView];
    CGSize existingSize = self.scrollView.contentSize;
    CGRect existingContent = CGRectMake(0, 0, existingSize.width, existingSize.height);
    self.scrollView.contentSize = CGRectUnion(existingContent, frame).size;
}

- (void) setActivityInProgress:(BOOL)inProgress forRank:(NSUInteger)rank
{
    MGMRankedAlbumView* albumView = [self albumViewForRank:rank];
    albumView.activityInProgress = inProgress;
}

- (void) setAlbumImage:(UIImage *)albumImage artistName:(NSString *)artistName albumName:(NSString *)albumName rank:(NSUInteger)rank listeners:(NSUInteger)listeners
{
    [self setAlbumImage:albumImage atRank:rank];

    MGMRankedAlbumView* albumView = [self albumViewForRank:rank];
    albumView.artistName = artistName;
    albumView.albumName = albumName;
    albumView.listeners = listeners;
}

- (void) setAlbumImage:(UIImage *)albumImage atRank:(NSUInteger)rank
{
    MGMRankedAlbumView* albumView = [self albumViewForRank:rank];
    [albumView renderImage:albumImage];
}

- (MGMRankedAlbumView*) albumViewForRank:(NSUInteger)rank
{
    for (MGMRankedAlbumView* view in self.albumViews)
    {
        if (view.rank == rank)
        {
            return view;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark MGMPressableAlbumViewDelegate

- (void) albumPressed:(MGMRankedAlbumView *)albumView
{
    [self.delegate albumPressedWithRank:albumView.rank];
}

- (void) detailPressed:(MGMRankedAlbumView *)albumView
{
    
}

@end
