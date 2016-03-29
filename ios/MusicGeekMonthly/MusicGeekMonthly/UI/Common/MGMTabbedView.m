//
//  MGMTabbedView.m
//  MusicGeekMonthly
//
//  Created by Home on 06/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedView.h"

@implementation MGMTabbedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _albumContainer = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:_albumContainer];
    }
    return self;
}

@end
