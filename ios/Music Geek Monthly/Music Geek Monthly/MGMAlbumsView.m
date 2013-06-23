//
//  MGMAlbumsView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 17/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumsView.h"
#import "MGMAlbumView.h"

@interface MGMAlbumsView () <MGMAlbumViewDelegate>

@property (strong) UIScrollView* scrollView;

@property (strong) NSMutableArray* albumViews;

@end

@implementation MGMAlbumsView

- (void) commonInit
{
    CGSize parentSize = self.frame.size;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, parentSize.width, parentSize.height)];
    [self addSubview:self.scrollView];

    self.albumViews = [NSMutableArray arrayWithCapacity:15];
}

- (void) clearAllAlbums
{
    for (MGMAlbumView* view in self.albumViews)
    {
        [view removeFromSuperview];
    }
    [self.albumViews removeAllObjects];
}

- (void) addAlbum:(UIImage *)albumImage artistName:(NSString *)artistName albumName:(NSString *)albumName rank:(NSUInteger)rank listeners:(NSUInteger)listeners atFrame:(CGRect)frame
{
    MGMAlbumView* albumView = [[MGMAlbumView alloc] initWithFrame:frame];
    albumView.albumImage = albumImage;
    albumView.artistName = artistName;
    albumView.albumName = albumName;
    albumView.rank = rank;
    albumView.listeners = listeners;
    albumView.delegate = self;
    [self.scrollView addSubview:albumView];
    [self.albumViews addObject:albumView];
    CGSize existingSize = self.scrollView.contentSize;
    CGRect existingContent = CGRectMake(0, 0, existingSize.width, existingSize.height);
    self.scrollView.contentSize = CGRectUnion(existingContent, frame).size;
}

- (void) updateAlbumImage:(UIImage *)albumImage atRank:(NSUInteger)rank
{
    MGMAlbumView* albumView = [self albumViewForRank:rank];
    albumView.albumImage = albumImage;
}

- (MGMAlbumView*) albumViewForRank:(NSUInteger)rank
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

@end
