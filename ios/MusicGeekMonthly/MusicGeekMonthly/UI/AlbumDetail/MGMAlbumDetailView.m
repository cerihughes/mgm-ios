//
//  MGMAlbumDetailView.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailView.h"

#import "MGMAlbumView.h"
#import "MGMPlayerGroupView.h"

@implementation MGMAlbumDetailView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
        _albumView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:self.groupView];
        [self addSubview:_albumView];
    }
    return self;
}

@end
