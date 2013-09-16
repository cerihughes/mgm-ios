//
//  MGMAlbumViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumViewController.h"

@interface MGMAlbumViewController () <MGMReachabilityManagerListener>

@end

@implementation MGMAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.core.reachabilityManager addListener:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.core.reachabilityManager removeListener:self];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MGMReachabilityManagerListener

- (void) reachabilityDetermined:(BOOL)reachability
{
    // Override
}

@end
