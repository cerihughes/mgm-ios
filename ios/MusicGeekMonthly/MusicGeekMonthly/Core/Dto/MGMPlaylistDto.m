//
//  MGMPlaylistDto.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPlaylistDto.h"

@implementation MGMPlaylistDto

- (id) init
{
    if (self = [super init])
    {
        self.playlistItems = [NSMutableArray array];
    }
    return self;
}

@end
