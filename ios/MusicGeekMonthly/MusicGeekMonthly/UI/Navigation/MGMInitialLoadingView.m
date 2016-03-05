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
    
    self.backgroundColor = [UIColor lightGrayColor];

    _parentView = [[UIView alloc] initWithFrame:CGRectZero];

    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iTunesArtworkTransparent.png"]];
    _statusLabel = [MGMView boldTitleLabelWithText:@"Initialising..."];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [_parentView addSubview:_imageView];
    [_parentView addSubview:_statusLabel];
    [_parentView addSubview:_activityIndicatorView];

    [self addSubview:_parentView];
}

- (void) setOperationInProgress:(BOOL)operationInProgress
{
    if (operationInProgress)
    {
        [_activityIndicatorView startAnimating];
    }
    else
    {
        [_activityIndicatorView stopAnimating];
    }
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

//    CGFloat parentOffset = (self.screenSize == MGMViewScreenSizeiPhone480) ? 0.0 : (576.0 - 480.0) / 2.0;
    CGFloat parentOffset = 0.0;

    self.parentView.frame = CGRectMake(0, parentOffset, 320, 480);

    self.statusLabel.frame = CGRectMake(20, 50, 280, 30);
    self.imageView.frame = CGRectMake(20, 100, 280, 280);
    self.activityIndicatorView.frame = CGRectMake(20, 400, 280, 50);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.parentView.frame = self.frame;

    self.imageView.frame = CGRectMake(128, 256, 512, 512);
    self.statusLabel.frame = CGRectMake(0, 800, 768, 60);
    self.activityIndicatorView.frame = CGRectMake(334, 850, 100, 100);
}

@end
