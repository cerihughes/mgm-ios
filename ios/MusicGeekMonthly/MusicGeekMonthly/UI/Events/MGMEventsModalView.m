//
//  MGMEventsModalView.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsModalView.h"

#import "NSLayoutConstraint+MGM.h"

@implementation MGMEventsModalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _eventsTable = [[UITableView alloc] initWithFrame:CGRectZero];
        _eventsTable.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_eventsTable];
    }
    return self;
}

- (void) cancelButtonPressed:(id)sender
{
    [self.delegate cancelButtonPressed:sender];
}

@end

@interface MGMEventsModalViewPhone ()

@property (nonatomic, readonly) UINavigationBar *navigationBar;

@end

@implementation MGMEventsModalViewPhone

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Previous Events"];
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
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherNavigationBar:self.navigationBar toSuperview:self]];

    // Events table
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherView:self.eventsTable belowNavigationBar:self.navigationBar withoutTabBarInSuperview:self]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end

@implementation MGMEventsModalViewPad

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Events table
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherView:self.eventsTable toView:self]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
