//
//  MGMNavigationViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMNavigationViewController.h"

#import "MGMEventsViewController.h"
#import "MGMHomeViewController.h"
#import "MGMWeeklyChartViewController.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMNavigationViewController ()

@property (weak) MGMUI* ui;

@end

@implementation MGMNavigationViewController

- (id) initWithUI:(MGMUI*)ui
{
    if (self = [super init])
    {
        self.ui = ui;
        [self createControllers];
    }
    return self;
}

- (void) createControllers
{
    MGMHomeViewController* homeViewController = [[MGMHomeViewController alloc] init];
    homeViewController.ui = self.ui;
    homeViewController.title = @"Home";
    homeViewController.albumSelectionDelegate = self.ui;

    MGMWeeklyChartViewController* weeklyChartViewController = [[MGMWeeklyChartViewController alloc] init];
    weeklyChartViewController.ui = self.ui;
    weeklyChartViewController.title = @"Weekly Charts";
    weeklyChartViewController.albumSelectionDelegate = self.ui;

    MGMEventsViewController* eventsViewController = [[MGMEventsViewController alloc] init];
    eventsViewController.ui = self.ui;
    eventsViewController.title = @"Previous Events";
    eventsViewController.albumSelectionDelegate = self.ui;

    UITabBarItem* homeTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
    homeTabBarItem.title = @"Home";
    UITabBarItem* weeklyChartTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:1];
    UITabBarItem* eventsTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];
    
    homeViewController.tabBarItem = homeTabBarItem;
    weeklyChartViewController.tabBarItem = weeklyChartTabBarItem;
    eventsViewController.tabBarItem = eventsTabBarItem;

    [self setViewControllers: @[homeViewController, weeklyChartViewController, eventsViewController]];
}

@end
