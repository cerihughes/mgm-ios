//
//  MGMNavigationController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 07/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMNavigationController.h"

#import "MGMInitialLoadingViewController.h"
#import "MGMTabBarController.h"

@interface MGMNavigationController () <MGMInitialLoadingViewControllerDelegate>

@property (readonly) MGMInitialLoadingViewController* loadingViewController;
@property (readonly) MGMTabBarController* tabBarController;

@end

@implementation MGMNavigationController
{
    BOOL _loadingViewControllerPushed;
    BOOL _tabBarControllerPushed;
}

- (id) initWithUI:(MGMUI*)ui
{
    if (self = [super init])
    {
        self.navigationBarHidden = YES;

        _loadingViewController = [[MGMInitialLoadingViewController alloc] init];
        _loadingViewController.ui = ui;
        _loadingViewController.delegate = self;
        _tabBarController = [[MGMTabBarController alloc] initWithUI:ui];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (_loadingViewControllerPushed == NO)
    {
        _loadingViewControllerPushed = YES;
        [self pushViewController:self.loadingViewController animated:NO];
    }
}

#pragma mark -
#pragma mark MGMInitialLoadingViewControllerDelegate

- (void) initialisationComplete
{
    if (_tabBarControllerPushed == NO)
    {
        _tabBarControllerPushed = YES;
        [self pushViewController:_tabBarController animated:YES];
    }
}

@end
