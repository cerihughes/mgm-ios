//
//  MGMTimePeriod.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 19/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTimePeriod.h"

@implementation MGMTimePeriod

@dynamic startDate;
@dynamic endDate;

static NSDateFormatter* groupHeaderFormatter;
static NSDateFormatter* groupItemFormatter;

+ (void)initialize
{
    // MMM yyyy
    groupHeaderFormatter = [[NSDateFormatter alloc] init];
    groupHeaderFormatter.dateFormat = @"MMM yyyy";

    // dd MMM
    groupItemFormatter = [[NSDateFormatter alloc] init];
    groupItemFormatter.dateFormat = @"dd MMM";
}

- (NSString*) groupHeader
{
    [self willAccessValueForKey:@"groupHeader"];
    NSString* header = [groupHeaderFormatter stringFromDate:self.startDate];
    [self didAccessValueForKey:@"groupHeader"];
    return header;
}

- (NSString*) groupValue
{
    [self willAccessValueForKey:@"groupValue"];
    NSString* startString = [groupItemFormatter stringFromDate:self.startDate];
    NSString* endString = [groupItemFormatter stringFromDate:self.endDate];
    NSString* groupValue = [NSString stringWithFormat:@"%@ - %@", startString, endString];
    [self didAccessValueForKey:@"groupValue"];
    return groupValue;
}

@end
