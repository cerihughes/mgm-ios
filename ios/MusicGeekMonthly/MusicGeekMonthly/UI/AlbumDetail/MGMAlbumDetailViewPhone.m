//
//  MGMAlbumDetailViewPhone.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 13/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailViewPhone.h"

#import "MGMAlbumView.h"
#import "MGMPlayerGroupView.h"

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
