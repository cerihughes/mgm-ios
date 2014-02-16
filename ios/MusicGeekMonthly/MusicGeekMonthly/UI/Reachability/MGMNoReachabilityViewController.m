//
//  MGMNoReachabilityViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMNoReachabilityViewController.h"

#import "MGMNoReachabilityView.h"

@implementation MGMNoReachabilityViewController

- (void) loadView
{
    MGMNoReachabilityView* view = [[MGMNoReachabilityView alloc] initWithFrame:[self fullscreenRect]];

    self.view = view;
}

@end
