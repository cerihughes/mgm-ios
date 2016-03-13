//
//  MGMAlbumDetailViewPad.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 13/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailViewPad.h"

#import "MGMAlbumView.h"
#import "MGMPlayerGroupView.h"

@interface MGMAlbumDetailViewPad ()

@property (readonly) UIButton* cancelButton;

@end

@implementation MGMAlbumDetailViewPad

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_cancelButton];
    }
    return self;
}

- (void) cancelButtonPressed:(id)sender
{
    [self.delegate cancelButtonPressed:sender];
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Cancel button
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.cancelButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:-20]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.cancelButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:20]];

    // Album view
    CGFloat albumSize = 250;

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
                                                           toItem:self.cancelButton
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    // Group view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:20]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
