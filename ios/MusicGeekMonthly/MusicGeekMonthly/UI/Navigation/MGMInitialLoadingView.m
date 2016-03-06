//
//  MGMInitialLoadingView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMInitialLoadingView.h"

#import "NSLayoutConstraint+MGM.h"
#import "UIScreen+MGM.h"

@interface MGMInitialLoadingView ()

@property (readonly) UIView* parentView;
@property (readonly) UIImageView* imageView;
@property (readonly) UILabel* statusLabel;
@property (readonly) UIActivityIndicatorView* activityIndicatorView;
@property (readonly) BOOL createdConstraints;

@end

@implementation MGMInitialLoadingView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];

        _parentView = [[UIView alloc] initWithFrame:frame];
        _parentView.translatesAutoresizingMaskIntoConstraints = NO;

        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iTunesArtworkTransparent.png"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;

        _statusLabel = [MGMView boldTitleLabelWithText:@"Initialising..."];
        _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;

        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;

        [_parentView addSubview:_imageView];
        [_parentView addSubview:_statusLabel];
        [_parentView addSubview:_activityIndicatorView];

        [self addSubview:_parentView];
    }
    return self;
}

- (void)updateConstraints
{
    if (!_createdConstraints) {

        _createdConstraints = YES;

        CGFloat spacing = 20.0;
        CGFloat widthBorder = 20.0;
        CGFloat heightBorder = 50.0;
        CGFloat maxParentWidth = 512.0;
        CGFloat maxParentHeight = 850.0;
        CGFloat parentWidth = [UIScreen mainScreen].mgm_smallestSizeMetric - (2 * widthBorder);
        CGFloat parentHeight = [UIScreen mainScreen].mgm_largestSizeMetric - (2 * heightBorder);
        parentWidth = MIN(parentWidth, maxParentWidth);
        parentHeight = MIN(parentHeight, maxParentHeight);

        NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

        // Parent
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_parentView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_parentView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_parentView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:parentWidth]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_parentView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1
                                                             constant:parentHeight]];

        // Image
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_imageView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0
                                                             priority:UILayoutPriorityDefaultHigh]];

        // Spacing
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:_statusLabel
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:-spacing]];

        // Status label
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_imageView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:0.1
                                                             constant:0]];

        // Spacing
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:_activityIndicatorView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:-spacing]];

        // Activity indicator
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_parentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_statusLabel
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:5/3
                                                             constant:0]];

        [NSLayoutConstraint activateConstraints:constraints];
    }
    [super updateConstraints];
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

@end
