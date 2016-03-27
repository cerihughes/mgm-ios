//
//  MGMEventsModalView.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsModalView.h"

@implementation MGMEventsModalViewPhone

- (instancetype)initWithFrame:(CGRect)frame
{
    UITableView *eventsTable = [[UITableView alloc] initWithFrame:frame];
    eventsTable.translatesAutoresizingMaskIntoConstraints = NO;
    return [super initWithFrame:frame tableView:eventsTable navigationTitle:@"Previous Events" buttonTitle:@"Cancel"];
}

@end

@implementation MGMEventsModalViewPad

- (instancetype)initWithFrame:(CGRect)frame
{
    UITableView *eventsTable = [[UITableView alloc] initWithFrame:frame];
    eventsTable.translatesAutoresizingMaskIntoConstraints = NO;
    return [super initWithFrame:frame tableView:eventsTable];
}

@end
