//
//  MGMPulsatingAlbumViewController.h
//  MusicGeekMonthly
//
//  Created by Home on 06/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedView.h"
#import "MGMViewController.h"

@import UIKit;

@interface MGMTabbedViewController<ViewType:MGMTabbedView *> : MGMViewController<ViewType>

@property (nonatomic, strong) ViewType view;

- (void) assignBackgroundView:(UIView*)backgroundView;

@end
