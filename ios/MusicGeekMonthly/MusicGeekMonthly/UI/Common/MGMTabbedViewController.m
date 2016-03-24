//
//  MGMPulsatingAlbumViewController.m
//  MusicGeekMonthly
//
//  Created by Home on 06/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedViewController.h"

@implementation MGMTabbedViewController

@dynamic view;

- (void) assignBackgroundView:(UIView *)backgroundView
{
    if ([self.view respondsToSelector:@selector(albumContainer)])
    {
        [self.view.albumContainer addSubview:backgroundView];
    }
}

@end
