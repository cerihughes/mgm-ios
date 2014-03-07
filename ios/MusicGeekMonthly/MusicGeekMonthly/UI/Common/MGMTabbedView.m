//
//  MGMTabbedView.m
//  MusicGeekMonthly
//
//  Created by Home on 06/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedView.h"

@implementation MGMTabbedView

- (void) commonInit
{
    [super commonInit];

    _albumContainer = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:_albumContainer];
}

@end
