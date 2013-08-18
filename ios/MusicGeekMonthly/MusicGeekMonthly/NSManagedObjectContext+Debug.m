//
//  NSManagedObjectContext+Debug.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "NSManagedObjectContext+Debug.h"

@implementation NSManagedObjectContext (Debug)

- (void) debugEntry:(NSString*)method
{
    NSLog(@"ENTRY: [%@].%@ on thread %@", self, method, [NSThread currentThread]);
}

- (void) debugExit:(NSString*)method
{
    NSLog(@"EXIT: [%@].%@ on thread %@", self, method, [NSThread currentThread]);
}

- (void) debugPerformBlock:(void (^)())block
{
    [self debugEntry:@"performBlock"];
    [self performBlock:block];
    [self debugExit:@"performBlock"];
}

- (void) debugPerformBlockAndWait:(void (^)())block
{
    [self debugEntry:@"performBlockAndWait"];
    [self performBlockAndWait:block];
    [self debugExit:@"performBlockAndWait"];
}

@end
