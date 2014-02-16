//
//  MGMPulsatingAlbumViewController.m
//  MusicGeekMonthly
//
//  Created by Home on 06/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedViewController.h"

#import "MGMTabbedView.h"

@implementation MGMTabbedViewController

- (void) assignBackgroundView:(UIView *)backgroundView
{
    if ([self.view respondsToSelector:@selector(albumContainer)])
    {
        MGMTabbedView* tabbedView = (MGMTabbedView*)self.view;
        [tabbedView.albumContainer addSubview:backgroundView];
    }
}

@end
