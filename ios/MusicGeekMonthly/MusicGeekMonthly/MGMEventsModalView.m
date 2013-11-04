//
//  MGMEventsModalView.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsModalView.h"

@interface MGMEventsModalView ()

@property (strong) UINavigationBar* navigationBar;
@property (strong) UITableView* eventsTable;

@end

@implementation MGMEventsModalView

- (void) commonInit
{
    [super commonInit];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Previous Events"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [self.navigationBar pushNavigationItem:navigationItem animated:YES];
    
    self.eventsTable = [[UITableView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.eventsTable];
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
    self.eventsTable.frame = tableFrame;
}

@end
