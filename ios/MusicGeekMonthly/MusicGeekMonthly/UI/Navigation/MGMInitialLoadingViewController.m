//
//  MGMInitialLoadingViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMInitialLoadingViewController.h"

#import "MGMInitialLoadingView.h"

@implementation MGMInitialLoadingViewController

- (void) loadView
{
    MGMInitialLoadingView* view = [[MGMInitialLoadingView alloc] initWithFrame:[self fullscreenRect]];

    self.view = view;
}

@end
