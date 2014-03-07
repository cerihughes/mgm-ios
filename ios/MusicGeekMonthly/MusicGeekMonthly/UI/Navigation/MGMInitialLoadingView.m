//
//  MGMInitialLoadingView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMInitialLoadingView.h"

@interface MGMInitialLoadingView ()

@property (readonly) UIView* parentView;
@property (readonly) UIImageView* imageView;
@property (readonly) UIActivityIndicatorView* activityIndicatorView;
@property (readonly) UILabel* statusLabel;

@end

@implementation MGMInitialLoadingView

- (void) commonInit
{
    [super commonInit];
    
    self.backgroundColor = [UIColor grayColor];

    _parentView = [[UIView alloc] initWithFrame:CGRectZero];

    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iTunesArtworkTransparent.png"]];
    _statusLabel = [MGMView boldTitleLabelWithText:@"Initialising..."];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [_parentView addSubview:_imageView];
    [_parentView addSubview:_statusLabel];
    [_parentView addSubview:_activityIndicatorView];

    [self addSubview:_parentView];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    CGFloat parentOffset = (self.screenSize == MGMViewScreenSizeiPhone480) ? 0.0 : (576.0 - 480.0) / 2.0;
    self.parentView.frame = CGRectMake(0, parentOffset, 320, 480);

    self.statusLabel.frame = CGRectMake(20, 20, 280, 30);
    self.imageView.frame = CGRectMake(20, 70, 280, 280);
    self.activityIndicatorView.frame = CGRectMake(20, 380, 280, 70);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.parentView.frame = self.frame;

    self.statusLabel.frame = CGRectMake(0, 100, 768, 60);
    self.imageView.frame = CGRectMake(128, 200, 512, 512);
    self.activityIndicatorView.frame = CGRectMake(128, 760, 512, 200);
}

@end
