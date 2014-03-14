//
//  MGMWeeklyChartAlbumsView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 17/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumGridView.h"

@interface MGMAlbumGridView () <MGMAlbumViewDelegate>

@property (readonly) UIScrollView* scrollView;
@property (readonly) NSLock* albumViewsLock;
@property (readonly) NSMutableArray* albumViews;

@end

@implementation MGMAlbumGridView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _albumViewsLock = [[NSLock alloc] init];
        _albumViews = [NSMutableArray arrayWithCapacity:25];
    }
    return self;
}

- (void) commonInit
{
    [super commonInit];

    CGSize parentSize = self.frame.size;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, parentSize.width, parentSize.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_scrollView];
}

- (NSUInteger) albumCount
{
    [self.albumViewsLock lock];
    @try
    {
        return self.albumViews.count;
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
}

- (void) setAlbumCount:(NSUInteger)albumCount detailViewShowing:(BOOL)detailViewShowing
{
    if (self.albumViews.count != albumCount)
    {
        [self.albumViewsLock lock];
        @try
        {
            for (NSUInteger i = albumCount + 1; i < self.albumViews.count; i++)
            {
                MGMAlbumView* albumView = [self internal_albumViewForRank:i];
                albumView.frame = CGRectZero;
                albumView.hidden = YES;
            }

            for (NSUInteger i = self.albumViews.count; i < albumCount; i++)
            {
                MGMAlbumView* albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
                albumView.alphaOn = 1;
                albumView.animationTime = 0.5;
                albumView.rank = i + 1;
                albumView.detailViewShowing = detailViewShowing;
                albumView.delegate = self;
                albumView.pressable = YES;

                [self.scrollView addSubview:albumView];
                [self.albumViews addObject:albumView];
            }
        }
        @finally
        {
            [self.albumViewsLock unlock];
        }

        self.scrollView.contentSize = CGSizeZero;
    }
}

- (void) setAlbumFrame:(CGRect)frame forRank:(NSUInteger)rank
{
    MGMAlbumView* albumView = [self albumViewForRank:rank];
    albumView.frame = frame;
    albumView.hidden = NO;

    CGSize existingSize = self.scrollView.contentSize;
    CGRect existingContent = CGRectMake(0, 0, existingSize.width, existingSize.height);
    self.scrollView.contentSize = CGRectUnion(existingContent, frame).size;
}

- (void) updateContentSize
{
    CGRect rect = CGRectZero;
    for (MGMAlbumView* albumView in self.albumViews)
    {
        rect = CGRectUnion(rect, albumView.frame);
    }
    self.scrollView.contentSize = rect.size;
}

- (void) setActivityInProgressForAllRanks:(BOOL)inProgress
{
    [self.albumViewsLock lock];
    @try
    {
        for (MGMAlbumView* albumView in self.albumViews)
        {
            albumView.activityInProgress = inProgress;
        }
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
}

- (MGMAlbumView*) albumViewForRank:(NSUInteger)rank
{
    [self.albumViewsLock lock];
    @try
    {
        return [self internal_albumViewForRank:rank];
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
}

- (MGMAlbumView*) internal_albumViewForRank:(NSUInteger)rank
{
    for (MGMAlbumView* view in self.albumViews)
    {
        if (view.rank == rank)
        {
            return view;
        }
    }

    // None of these views have ranks, so let's return the index in the array...
    if (self.albumViews.count >= rank)
    {
        return self.albumViews[rank - 1];
    }
    return nil;
}

#pragma mark -
#pragma mark MGMAlbumViewDelegate

- (void) albumPressed:(MGMAlbumView *)albumView
{
    [self.delegate albumPressedWithRank:albumView.rank];
}

- (void) detailPressed:(MGMAlbumView *)albumView
{
    [self.delegate detailPressedWithRank:albumView.rank];
}

@end
