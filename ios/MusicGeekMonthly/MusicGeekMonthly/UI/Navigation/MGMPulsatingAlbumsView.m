//
//  MGMPulsatingAlbumsView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPulsatingAlbumsView.h"
#import "MGMAlbumView.h"

@interface MGMPulsatingAlbumsView ()

@property (readonly) NSLock* albumViewsLock;
@property (readonly) NSMutableArray* albumViews;

@end

@implementation MGMPulsatingAlbumsView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _albumViewsLock = [[NSLock alloc] init];
        _albumViews = [NSMutableArray array];
    }
    return self;
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

- (void) setupAlbumsInRow:(NSUInteger)albumsInRow
{
    CGSize size = self.frame.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat albumWidth = width / albumsInRow;
    NSUInteger albumsInColumn = (height / albumWidth) + 1;

    [self.albumViewsLock lock];
    @try
    {
        for (NSUInteger row = 0; row < albumsInRow; row++)
        {
            for (NSUInteger column = 0; column < albumsInColumn; column++)
            {
                CGRect frame = CGRectMake(row * albumWidth, column * albumWidth, albumWidth, albumWidth);
                MGMAlbumView* imageView = [[MGMAlbumView alloc] initWithFrame:frame];
                imageView.alphaOn = 0.15;
                imageView.animationTime = 3;
                [self addSubview:imageView];
                [self.albumViews addObject:imageView];
            }
        }
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
}

- (CGSize) albumSize
{
    [self.albumViewsLock lock];
    @try
    {
        if (self.albumViews.count > 0)
        {
            MGMAlbumView* view = [self.albumViews objectAtIndex:0];
            return view.frame.size;
        }
        return CGSizeZero;
    }
    @finally
    {
        [self.albumViewsLock unlock];
    }
}

- (void) renderImage:(UIImage*)image atIndex:(NSUInteger)index animation:(BOOL)animation
{
    if (index < self.albumCount)
    {
        [self.albumViewsLock lock];
        MGMAlbumView* albumView;
        @try
        {
            albumView = [self.albumViews objectAtIndex:index];
        }
        @finally
        {
            [self.albumViewsLock unlock];
        }

        if (animation)
        {
            [albumView fadeOutAndRenderImage:image];
        }
        else
        {
            [albumView renderImageWithNoAnimation:image];
        }
    }
}

@end
