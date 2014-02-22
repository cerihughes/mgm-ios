//
//  MGMWeeklyChartAlbumsView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 17/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartAlbumsView.h"
#import "MGMAlbumView.h"

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

- (void) setupAlbumFrame:(CGRect)frame forRank:(NSUInteger)rank
{
    MGMAlbumView* albumView = [[MGMAlbumView alloc] initWithFrame:frame];
    albumView.alphaOn = 1;
    albumView.animationTime = 0.5;
    albumView.rank = rank;
    albumView.detailViewShowing = NO;
    albumView.delegate = self;
    albumView.pressable = NO;

    [self.albumViewsLock lock];
    @try
    {
        [self.scrollView addSubview:albumView];
        [self.albumViews addObject:albumView];
        CGSize existingSize = self.scrollView.contentSize;
        CGRect existingContent = CGRectMake(0, 0, existingSize.width, existingSize.height);
        self.scrollView.contentSize = CGRectUnion(existingContent, frame).size;
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
}

- (CGSize) sizeOfRank:(NSUInteger)rank
{
    MGMAlbumView* albumView = [self albumViewForRank:rank];
    if (albumView)
    {
        return albumView.frame.size;
    }
    return CGSizeZero;
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
        for (MGMAlbumView* view in self.albumViews)
        {
            if (view.rank == rank)
            {
                return view;
            }
        }
        return nil;
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
}

- (void) clearAllAlbumFrames
{
    [self.albumViewsLock lock];
    @try
    {
        for (MGMAlbumView* albumView in self.albumViews)
        {
            [albumView removeFromSuperview];
        }
        [self.albumViews removeAllObjects];
        self.scrollView.contentSize = CGSizeZero;
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
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
