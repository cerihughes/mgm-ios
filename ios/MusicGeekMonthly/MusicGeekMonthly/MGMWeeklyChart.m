//
//  MGMWeeklyChart.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChart.h"

@implementation MGMWeeklyChart

@dynamic startDate;
@dynamic endDate;
@dynamic chartEntries;

// Horseshit iOS doesn't implement these properly and Apple (naturally) don't advertise the bug: http://stackoverflow.com/questions/7385439/exception-thrown-in-nsorderedset-generated-accessors (not fixed in iOS6). Also https://devforums.apple.com/message/470731#470731

- (void) addChartEntriesObject:(MGMChartEntry *)value
{
    [self willAccessValueForKey:@"chartEntries"];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:[[self primitiveChartEntries] count]];
    [self didAccessValueForKey:@"chartEntries"];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"chartEntries"];
    [[self primitiveChartEntries] addObject:value];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"chartEntries"];
}


@end
