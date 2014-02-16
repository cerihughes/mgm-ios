//
//  MGMWeeklyChartDto.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartDto.h"

@implementation MGMWeeklyChartDto

- (id) init
{
    if (self = [super init])
    {
        self.chartEntries = [NSMutableArray array];
    }
    return self;
}

@end
