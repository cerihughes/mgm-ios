//
//  MGMImagedEntityDto.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 28/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMImagedEntityDto.h"

@implementation MGMImagedEntityDto

- (id) init
{
    if (self = [super init])
    {
        self.imageUris = [NSMutableArray array];
    }
    return self;
}

@end
