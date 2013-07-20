//
//  MGMHomeViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeViewController.h"

@interface MGMHomeViewController ()

- (IBAction) previousEventsPressed:(id)sender;
- (IBAction) nextEventPressed:(id)sender;
- (IBAction) chartsPressed:(id)sender;

@end

@implementation MGMHomeViewController

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
    }
    return self;
}

- (IBAction) previousEventsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionPreviousEvents];
}

- (IBAction) nextEventPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionNextEvent];
}

- (IBAction) chartsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionCharts];
}

@end
