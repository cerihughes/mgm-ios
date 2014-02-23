//
//  MGMNoReachabilityView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMNoReachabilityView.h"

@interface MGMNoReachabilityView ()

@property (readonly) UIView* parentView;
@property (readonly) UIImageView* imageView;
@property (readonly) UILabel* titleLabel;
@property (readonly) UILabel* reachabilityLabel;

@end

@implementation MGMNoReachabilityView

- (void) commonInit
{
    self.backgroundColor = [UIColor grayColor];

    _parentView = [[UIView alloc] initWithFrame:CGRectZero];

    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iTunesArtworkTransparent.png"]];
    _titleLabel = [MGMView boldTitleLabelWithText:@"No internet connection detected"];
    _reachabilityLabel = [MGMView italicTitleLabelWithText:@"Music Geek Monthly requires an initial internet connection to download data."];
    _reachabilityLabel.numberOfLines = 5;

    [_parentView addSubview:_imageView];
    [_parentView addSubview:_titleLabel];
    [_parentView addSubview:_reachabilityLabel];

    [self addSubview:_parentView];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    CGFloat parentOffset = (self.screenSize == MGMViewScreenSizeiPhone480) ? 0.0 : (576.0 - 480.0) / 2.0;
    self.parentView.frame = CGRectMake(0, parentOffset, 320, 480);

    self.titleLabel.frame = CGRectMake(20, 20, 280, 30);
    self.imageView.frame = CGRectMake(20, 70, 280, 280);
    self.reachabilityLabel.frame = CGRectMake(20, 380, 280, 70);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.parentView.frame = self.frame;

    self.titleLabel.frame = CGRectMake(0, 100, 768, 60);
    self.imageView.frame = CGRectMake(128, 200, 512, 512);
    self.reachabilityLabel.frame = CGRectMake(128, 760, 512, 200);
}

@end
