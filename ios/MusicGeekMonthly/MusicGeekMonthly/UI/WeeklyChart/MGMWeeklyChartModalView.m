//
//  MGMWeeklyChartModalView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartModalView.h"

@interface MGMWeeklyChartModalView ()

@property (strong) UINavigationBar* navigationBar;
@property (strong) UITableView* timePeriodTable;

@end

@implementation MGMWeeklyChartModalView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];
    self.timePeriodTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.timePeriodTable];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Weekly Charts"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [self.navigationBar pushNavigationItem:navigationItem animated:YES];

    [self addSubview:self.navigationBar];
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
