//
//  MGMAlbumScoresView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoresView.h"

#import "MGMAlbumGridView.h"
#import "NSLayoutConstraint+MGM.h"

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
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherNavigationBar:self.navigationBar toSuperview:self]];

    // Album grid
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherView:self.albumGridView belowNavigationBar:self.navigationBar aboveTabBarInSuperview:self]];

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
