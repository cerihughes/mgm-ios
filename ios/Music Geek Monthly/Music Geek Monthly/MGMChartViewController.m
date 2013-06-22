//
//  MGMChartViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 22/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMChartViewController.h"
#import "MGMWeeklyTimePeriodViewController.h"
#import "MGMWeeklyChartViewController.h"

@interface MGMChartViewController() <UISplitViewControllerDelegate>

@property MGMWeeklyTimePeriodViewController* datesViewController;
@property MGMWeeklyChartViewController* chartViewController;

@end

@implementation MGMChartViewController

- (id)init
{
    if (self = [super init])
    {
        self.datesViewController = [[MGMWeeklyTimePeriodViewController alloc] init];
        self.chartViewController = [[MGMWeeklyChartViewController alloc] init];

        UINavigationController* datesViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.datesViewController];
        UINavigationController* chartViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.chartViewController];

        self.viewControllers = [NSArray arrayWithObjects:datesViewNavigationController, chartViewNavigationController, nil];
        self.delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController*)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc
{
    
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController*)aViewController invalidatingBarButtonItem:(UIBarButtonItem*)barButtonItem
{

}

@end
