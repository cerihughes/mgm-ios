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

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherNavigationBar:self.navigationBar toSuperview:self]];

    // Album grid
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumGridView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
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
                                                         constant:-self.tabBarHeight]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
