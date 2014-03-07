//
//  MGMWeeklyChartModalView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartModalView.h"

@interface MGMWeeklyChartModalView ()

@property (readonly) UINavigationBar* navigationBar;

@end

@implementation MGMWeeklyChartModalView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];
    _timePeriodTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [self addSubview:_timePeriodTable];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Weekly Charts"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [_navigationBar pushNavigationItem:navigationItem animated:YES];

    [self addSubview:_navigationBar];
}

- (void) cancelButtonPressed:(id)sender
{
    [self.delegate cancelButtonPressed:sender];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);

    CGRect tableFrame = CGRectMake(0, 64, 320, self.frame.size.height - 64);
    self.timePeriodTable.frame = tableFrame;
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.timePeriodTable.frame = self.frame;
}

@end
