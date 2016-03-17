//
//  MGMExampleAlbumView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMExampleAlbumView.h"

#import "MGMAlbumView.h"

#define EXAMPLE_TEXT @"You can see all available options for an album by pressing the 'detail' button (i) at any time"

@interface MGMExampleAlbumView () <MGMAlbumViewDelegate>

@property (readonly) UILabel* label;

@end

@implementation MGMExampleAlbumView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
        _albumView.translatesAutoresizingMaskIntoConstraints = NO;
        _albumView.animationTime = 0.25;
        _albumView.pressable = YES;
        _albumView.delegate = self;
        _albumView.detailViewShowing = YES;

        _label = [MGMView italicTitleLabelWithText:EXAMPLE_TEXT];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.numberOfLines = 5;

        [self addSubview:_albumView];
        [self addSubview:_label];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Label
    CGFloat labelInset = 10;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.label
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.label
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:-2 * labelInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.label
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:-labelInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.label
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:labelInset]];

    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark -
#pragma mark MGMAlbumViewDelegate

- (void) albumPressed:(MGMAlbumView*)albumView
{
    [self.delegate gotIt];
}

- (void) detailPressed:(MGMAlbumView*)albumView
{
    [self.delegate gotIt];
}

@end

@implementation MGMExampleAlbumViewPhone

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Album view
    CGFloat albumSize = 240;
    CGFloat topOffset = 90;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:albumSize]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:topOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end

@implementation MGMExampleAlbumViewPad

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Album view
    CGFloat albumSize = 250;
    CGFloat topOffset = 75;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:albumSize]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:topOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
