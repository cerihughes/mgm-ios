//
//  MGMNextUrlAccess.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MGMNextUrlAccess : NSManagedObject

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSDate* date;

@end
