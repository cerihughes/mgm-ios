//
//  MGMWeeklyChartView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartView.h"

#import "MGMAlbumGridView.h"
#import "NSLayoutConstraint+MGM.h"

@interface MGMWeeklyChartView ()

@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UINavigationItem* navigationItem;

@end

@implementation MGMWeeklyChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        _navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"More..." style:UIBarButtonItemStyleBordered target:self action:@selector(moreButtonPressed:)];
        [_navigationItem setRightBarButtonItem:bbi];
        [_navigationBar pushNavigationItem:_navigationItem animated:YES];

        _albumGridView = [[MGMAlbumGridView alloc] initWithFrame:frame];
        _albumGridView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_navigationBar];
        [self addSubview:_albumGridView];
    }
    return self;
}

- (void) setTitle:(NSString*)title
{
    self.navigationItem.title = title;
}

- (void) moreButtonPressed:(id)sender
{
    [self.delegate moreButtonPressed:sender];
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Navigation bar
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherNavigationBar:self.navigationBar toSuperview:self]];

    // Album grid
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherView:self.albumGridView belowNavigationBar:self.navigationBar aboveTabBarInSuperview:self]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
