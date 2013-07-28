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

@property (strong) UIImageView* imageView;

@end

@implementation MGMPulsatingAlbumView

- (void) commonInit
{
    CGSize parentSize = self.frame.size;
    CGRect frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.alpha = ALPHA_ON;
    [self addSubview:self.imageView];
}

- (void) renderImage:(UIImage*)image afterDelay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:ANIMATION_TIME delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        self.imageView.alpha = ALPHA_OFF;
    }
    completion:^(BOOL finished)
    {
        self.imageView.image = image;
        if (image)
        {
            [UIView animateWithDuration:ANIMATION_TIME animations:^
            {
                self.imageView.alpha = ALPHA_ON;
            }];
        }
    }];
}

@end
