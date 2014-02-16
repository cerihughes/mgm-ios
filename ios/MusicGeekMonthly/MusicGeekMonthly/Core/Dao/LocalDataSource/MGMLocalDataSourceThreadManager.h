//
//  MGMLocalDataSourceThreadManager.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface MGMLocalDataSourceThreadManager : NSObject

- (id) init __unavailable;
- (id) initWithStoreName:(NSString*)storeName;

- (NSManagedObjectContext*) managedObjectContextForCurrentThread;

@end
