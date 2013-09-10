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
    homeViewController.tabBarItem.title = @"Home";
    homeViewController.tabBarItem.image = [UIImage imageNamed:@"home.png"];

    MGMWeeklyChartViewController* weeklyChartViewController = [[MGMWeeklyChartViewController alloc] init];
    weeklyChartViewController.ui = self.ui;
    weeklyChartViewController.title = @"Weekly Charts";
    weeklyChartViewController.albumSelectionDelegate = self.ui;
    weeklyChartViewController.tabBarItem.title = @"Weekly Charts";
    weeklyChartViewController.tabBarItem.image = [UIImage imageNamed:@"chart_line.png"];

    MGMEventsViewController* eventsViewController = [[MGMEventsViewController alloc] init];
    eventsViewController.ui = self.ui;
    eventsViewController.title = @"Previous Events";
    eventsViewController.albumSelectionDelegate = self.ui;
    eventsViewController.tabBarItem.title = @"Previous Events";
    eventsViewController.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];

    [self setViewControllers: @[homeViewController, weeklyChartViewController, eventsViewController]];
}

@end
