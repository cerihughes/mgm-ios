//
//  MGMPulsatingAlbumsView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPulsatingAlbumsView.h"
#import "MGMPulsatingAlbumView.h"

@interface MGMPulsatingAlbumsView ()

@property (strong) NSMutableArray* albumViews;

@end

@implementation MGMPulsatingAlbumsView

- (void) setupAlbumsInRow:(NSUInteger)albumsInRow
{
    self.albumViews = [NSMutableArray array];
    
    CGSize size = self.frame.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat albumWidth = width / albumsInRow;
    NSUInteger albumsInColumn = (height / albumWidth) + 1;

    for (NSUInteger row = 0; row < albumsInRow; row++)
    {
        for (NSUInteger column = 0; column < albumsInColumn; column++)
        {
            CGRect frame = CGRectMake(row * albumWidth, column * albumWidth, albumWidth, albumWidth);
            MGMPulsatingAlbumView* imageView = [[MGMPulsatingAlbumView alloc] initWithFrame:frame];
            [self addSubview:imageView];
            [self.albumViews addObject:imageView];
        }
    }
}

- (void) renderImages:(NSArray *)images
{
    NSArray* shuffled = [self shuffledCopy:self.albumViews];
    for (NSUInteger i = 0; i < shuffled.count; i++)
    {
        MGMPulsatingAlbumView* albumView = [shuffled objectAtIndex:i];
        [albumView renderImage:[self randomImageFromArray:images] afterDelay:i / 4.0];
    }
}

- (NSArray*) shuffledCopy:(NSArray*)input
{
    NSMutableArray* copy = [input mutableCopy];
    for (int i = [input count] - 1; i > 0; i--)
    {
        int j = arc4random() % (i + 1);
        [copy exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    return [copy copy];
}

- (UIImage*) randomImageFromArray:(NSArray*)images
{
    int index = arc4random() % images.count;
    return [images objectAtIndex:index];
}

@end
