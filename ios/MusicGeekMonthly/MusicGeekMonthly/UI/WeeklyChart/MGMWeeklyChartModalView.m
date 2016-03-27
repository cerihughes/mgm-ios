//
//  MGMWeeklyChartModalView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartModalView.h"

@implementation MGMWeeklyChartModalViewPhone

- (instancetype)initWithFrame:(CGRect)frame
{
    UITableView *eventsTable = [[UITableView alloc] initWithFrame:frame];
    eventsTable.translatesAutoresizingMaskIntoConstraints = NO;
    return [super initWithFrame:frame tableView:eventsTable navigationTitle:@"Weekly Charts" buttonTitle:@"Cancel"];
}

@end

@implementation MGMWeeklyChartModalViewPad

- (instancetype)initWithFrame:(CGRect)frame
{
    UITableView *eventsTable = [[UITableView alloc] initWithFrame:frame];
    eventsTable.translatesAutoresizingMaskIntoConstraints = NO;
    return [super initWithFrame:frame tableView:eventsTable];
}

@end