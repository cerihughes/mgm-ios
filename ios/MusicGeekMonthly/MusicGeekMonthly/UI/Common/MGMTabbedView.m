//
//  MGMTabbedView.m
//  MusicGeekMonthly
//
//  Created by Home on 06/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedView.h"

@interface MGMTabbedView ()

@property (strong) UIView* albumContainer;

@end

@implementation MGMTabbedView

- (void) commonInit
{
    [super commonInit];

    self.albumContainer = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:self.albumContainer];
}

@end
