//
//  MGMTimePerios.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 19/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTimePeriod.h"

@implementation MGMTimePeriod

+ (MGMTimePeriod*) timePeriodWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    return [[MGMTimePeriod alloc] initWithStartDate:startDate endDate:endDate];
}

- (id) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    if (self = [super init])
    {
        self.startDate = startDate;
        self.endDate = endDate;
    }
    return self;
}

@end
