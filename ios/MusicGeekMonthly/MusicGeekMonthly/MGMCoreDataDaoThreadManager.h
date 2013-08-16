//
//  MGMCoreDataDaoThreadManager.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MGMCoreDataDaoThreadManager : NSObject

- (id) init;
- (id) initWithStoreName:(NSString*)storeName;

- (NSManagedObjectContext*) managedObjectContextForCurrentThread;

@end
