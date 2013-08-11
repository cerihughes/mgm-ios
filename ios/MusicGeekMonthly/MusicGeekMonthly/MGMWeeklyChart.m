//
//  MGMWeeklyChart.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChart.h"

@implementation MGMWeeklyChart

@dynamic albums;
@dynamic timePeriod;

#pragma mark -
#pragma mark Horseshit iOS doesn't implement these properly and Apple (naturally) don't advertise the bug: http://stackoverflow.com/questions/7385439/exception-thrown-in-nsorderedset-generated-accessors (not fixed in iOS6).

- (void) addAlbumsObject:(MGMAlbum*)value
{
    NSSet* changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"albums" withSetMutation:NSKeyValueIntersectSetMutation usingObjects:changedObjects];
    [[self primitiveAlbums] addObject:value];
    [self didChangeValueForKey:@"albums" withSetMutation:NSKeyValueIntersectSetMutation usingObjects:changedObjects];
}

- (void) addAlbums:(NSOrderedSet*)values
{
    [self willChangeValueForKey:@"albums" withSetMutation:NSKeyValueIntersectSetMutation usingObjects:[values set]];
    [[self primitiveAlbums] unionSet:[values set]];
    [self didChangeValueForKey:@"albums" withSetMutation:NSKeyValueIntersectSetMutation usingObjects:[values set]];
}

@end
