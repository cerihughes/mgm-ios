//
//  MGMWeeklyTimePeriodViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 22/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyTimePeriodViewController.h"

@interface MGMWeeklyTimePeriodViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak) MGMUI* ui;
@property (strong) NSArray* timePeriods;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMWeeklyTimePeriodViewController

#define CELL_ID @"MGMWeeklyTimePeriodViewControllerCellId"

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        self.timePeriods = [self.core.daoFactory.lastFmDao weeklyTimePeriods];

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self.tableView reloadData];
        });
    });
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timePeriods.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    NSUInteger row = indexPath.row;
    MGMTimePeriod* period = [self.timePeriods objectAtIndex:row];
	NSString* startString = [self.dateFormatter stringFromDate:period.startDate];
	NSString* endString = [self.dateFormatter stringFromDate:period.endDate];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", startString, endString];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
}

@end
