//
//  NSManagedObjectContext+Debug.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Debug)

- (void) debugPerformBlock:(void (^)())block;
- (void) debugPerformBlockAndWait:(void (^)())block;

@end
