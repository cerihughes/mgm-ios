//
//  MGMAlbumDto.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDto.h"

@implementation MGMAlbumDto

- (id) init
{
    if (self = [super init])
    {
        self.metadata = [NSMutableArray array];
    }
    return self;
}

@end
