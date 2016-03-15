//
//  MGMAlbumDetailView.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailView.h"

#import "MGMAlbumView.h"
#import "MGMPlayerGroupView.h"

@implementation MGMAlbumDetailView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
        _albumView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:self.groupView];
        [self addSubview:_albumView];
    }
    return self;
}

- (void) cancelButtonPressed:(id)sender
{
    [self.delegate cancelButtonPressed:sender];
}

@end

@interface MGMAlbumDetailViewPhone ()

@property (readonly) UINavigationBar* navigationBar;

@end

@implementation MGMAlbumDetailViewPhone

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Album Detail"];
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
        [navigationItem setRightBarButtonItem:bbi];
        [_navigationBar pushNavigationItem:navigationItem animated:YES];

        [self addSubview:_navigationBar];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Navigation bar
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:20]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:44]];

    // Album view
    CGFloat albumSize = 240;

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
                                                           toItem:self.navigationBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:5]];

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
                                                         constant:5]];

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
