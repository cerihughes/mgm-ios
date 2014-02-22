//
//  MGMPlaylistItemDto.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPlaylistItemDto.h"

@implementation MGMPlaylistItemDto

- (id) init
{
    if (self = [super init])
    {
        self.imageUris = [NSMutableArray array];
    }
    return self;
}

@end
