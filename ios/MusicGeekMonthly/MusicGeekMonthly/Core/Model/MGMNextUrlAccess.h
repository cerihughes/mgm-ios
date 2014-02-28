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

@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* checksum;

@end
