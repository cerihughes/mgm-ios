//
//  MGMPulsatingAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 24/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPulsatingAlbumView.h"

#define ALPHA_OFF 0
#define ALPHA_ON 0.15
#define ANIMATION_TIME 3

@interface MGMPulsatingAlbumView ()

@property (strong) UIImageView* imageView1;
@property (strong) UIImageView* imageView2;

@end

@implementation MGMPulsatingAlbumView

- (void) commonInit
{
    CGSize parentSize = self.frame.size;
    CGRect frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    self.imageView1 = [[UIImageView alloc] initWithFrame:frame];
    self.imageView2 = [[UIImageView alloc] initWithFrame:frame];

    self.imageView1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    self.imageView1.alpha = ALPHA_ON;
    self.imageView2.alpha = ALPHA_OFF;

    [self addSubview:self.imageView1];
    [self addSubview:self.imageView2];
}

- (void) renderImage:(UIImage*)image afterDelay:(NSTimeInterval)delay
{
    UIImageView* from;
    UIImageView* to;
    if (self.imageView1.alpha == ALPHA_OFF)
    {
        from = self.imageView2;
        to = self.imageView1;
    }
    else
    {
        from = self.imageView1;
        to = self.imageView2;
    }

    [MGMPulsatingAlbumView renderImage:image toImageView:to andClearImageView:from afterDelay:delay];
}

+ (void) renderImage:(UIImage*)image toImageView:(UIImageView*)newImageView andClearImageView:(UIImageView*)oldImageView afterDelay:(NSUInteger)delay
{
    newImageView.image = image;
    [UIView animateWithDuration:ANIMATION_TIME delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        oldImageView.alpha = ALPHA_OFF;
    }
    completion:^(BOOL finished)
    {
        [UIView animateWithDuration:ANIMATION_TIME animations:^
        {
            oldImageView.image = nil;
            newImageView.alpha = ALPHA_ON;
        }];
    }];
}

@end
