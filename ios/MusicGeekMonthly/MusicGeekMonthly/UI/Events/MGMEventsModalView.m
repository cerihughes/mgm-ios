//
//  MGMEventsModalView.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsModalView.h"

@interface MGMEventsModalView ()

@property (readonly) UINavigationBar* navigationBar;

@end

@implementation MGMEventsModalView

- (void) commonInit
{
    [super commonInit];
    
    self.backgroundColor = [UIColor whiteColor];
    _eventsTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [self addSubview:_eventsTable];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Previous Events"];
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
    self.eventsTable.frame = tableFrame;
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];
    
    self.eventsTable.frame = self.frame;
}

@end
