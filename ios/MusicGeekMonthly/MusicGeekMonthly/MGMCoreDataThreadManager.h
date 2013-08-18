//
//  MGMCoreDataThreadManager.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface MGMCoreDataThreadManager : NSObject

- (id) initWithStoreName:(NSString*)storeName;

- (NSManagedObjectContext*) managedObjectContextForCurrentThread;

@end
