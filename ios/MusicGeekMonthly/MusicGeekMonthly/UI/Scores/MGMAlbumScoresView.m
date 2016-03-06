//
//  MGMAlbumScoresView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoresView.h"

#import "MGMAlbumGridView.h"

@interface MGMAlbumScoresView ()

@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UISegmentedControl* segmentedControl;

@end

@implementation MGMAlbumScoresView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@""];

        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Classic Albums", @"New Albums", @"All Albums"]];
        [_segmentedControl addTarget:self action:@selector(controlChanged:) forControlEvents:UIControlEventValueChanged];

        navigationItem.titleView = _segmentedControl;
        [_navigationBar pushNavigationItem:navigationItem animated:YES];

        _albumGridView = [[MGMAlbumGridView alloc] initWithFrame:frame];
        _albumGridView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_albumGridView];
        [self addSubview:_navigationBar];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray *constraints = [NSMutableArray array];

    // Navigation bar
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

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    // Album grid
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumGridView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.navigationBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumGridView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumGridView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumGridView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

- (void) controlChanged:(UISegmentedControl*)sender
{
    [self.delegate selectionChanged:(MGMAlbumScoresViewSelection)sender.selectedSegmentIndex];
}

- (void) setSelection:(MGMAlbumScoresViewSelection)selection
{
    self.segmentedControl.selectedSegmentIndex = selection;

    // Fire the delegate, as this won't happen automatically when setting.
    [self controlChanged:self.segmentedControl];
}

@end
