//
//  MGMTimePeriod.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 19/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGMRenderable.h"

@class MGMWeeklyChart;

@interface MGMTimePeriod : NSManagedObject<MGMRenderable>

@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSDate* endDate;

@property (readonly) NSString* groupHeader;
@property (readonly) NSString* groupValue;

@end
