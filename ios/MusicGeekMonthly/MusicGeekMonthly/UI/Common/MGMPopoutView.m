//
//  MGMPopoutView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 27/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMPopoutView.h"

#import "NSLayoutConstraint+MGM.h"

@implementation MGMPopoutView

- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _tableView = tableView;
        [self addSubview:_tableView];
    }
    return self;
}

- (void) cancelButtonPressed:(id)sender
{
    [self.delegate cancelButtonPressed:sender];
}

@end

@interface MGMPopoutViewPhone ()

@property (nonatomic, readonly) UINavigationBar *navigationBar;

@end

@implementation MGMPopoutViewPhone

- (instancetype)initWithFrame:(CGRect)frame
                    tableView:(UITableView *)tableView
              navigationTitle:(NSString *)navigationTitle
                  buttonTitle:(NSString *)buttonTitle
{
    self = [super initWithFrame:frame tableView:tableView];
    if (self) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:navigationTitle];
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
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
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherView:self.tableView belowNavigationBar:self.navigationBar withoutTabBarInSuperview:self]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end

@implementation MGMPopoutViewPad

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Events table
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherView:self.tableView toView:self]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
