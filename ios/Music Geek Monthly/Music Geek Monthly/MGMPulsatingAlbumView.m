//
//  MGMPulsatingAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 24/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPulsatingAlbumView.h"

@interface MGMPulsatingAlbumView ()

@property (strong) UIImageView* imageView;

@end

@implementation MGMPulsatingAlbumView

- (void) commonInit
{
    self.alphaOff = 0;
    self.alphaOn = 0.9;
    self.animationTime = 1;
    CGSize parentSize = self.frame.size;
    CGRect frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.alpha = self.alphaOn;
    [self addSubview:self.imageView];
}

- (void) renderImageWithNoAnimation:(UIImage*)image
{
    self.imageView.image = image;
    self.imageView.alpha = self.alphaOn;
}

- (void) renderImage:(UIImage*)image
{
    [self renderImage:image afterDelay:0];
}

- (void) renderImage:(UIImage*)image afterDelay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:self.animationTime delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        self.imageView.alpha = self.alphaOff;
    }
    completion:^(BOOL finished)
    {
        self.imageView.image = image;
        if (image)
        {
            [UIView animateWithDuration:self.animationTime animations:^
            {
                self.imageView.alpha = self.alphaOn;
            }];
        }
    }];
}

@end
