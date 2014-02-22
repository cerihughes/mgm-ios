//
//  MGMWeeklyChartAlbumsView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 17/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumGridView.h"

@interface MGMAlbumGridView () <MGMAlbumViewDelegate>

@property (strong) UIScrollView* scrollView;
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, parentSize.width, parentSize.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.scrollView];
}

- (void) setAlbumCount:(NSUInteger)albumCount
{
    if (self.albumViews.count != albumCount)
    {
        [self.albumViewsLock lock];
        @try
        {
            for (NSUInteger i = albumCount; i < self.albumViews.count; i++)
            {
                MGMAlbumView* albumView = [self internal_albumViewForRank:i];
                albumView.frame = CGRectZero;
            }

            for (NSUInteger i = self.albumViews.count; i < albumCount; i++)
            {
                MGMAlbumView* albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
                albumView.alphaOn = 1;
                albumView.animationTime = 0.5;
                albumView.rank = i + 1;
                albumView.detailViewShowing = NO;
                albumView.delegate = self;
                albumView.pressable = NO;

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
    [albumView setNeedsLayout];

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

- (void) setActivityInProgress:(BOOL)inProgress forRank:(NSUInteger)rank
{
    MGMAlbumView* albumView = [self albumViewForRank:rank];
    albumView.activityInProgress = inProgress;
}

- (void) setAlbumImage:(UIImage*)albumImage artistName:(NSString*)artistName albumName:(NSString*)albumName rank:(NSUInteger)rank listeners:(NSUInteger)listeners score:(CGFloat)score
{
    MGMAlbumView* albumView = [self albumViewForRank:rank];
    albumView.pressable = YES;
    albumView.detailViewShowing = YES;
    albumView.artistName = artistName;
    albumView.albumName = albumName;
    albumView.listeners = listeners;
    albumView.score = score;
    [albumView renderImage:albumImage];
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
