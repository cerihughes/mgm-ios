//
//  MGMTimePeriod.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 19/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MGMTimePeriod : NSManagedObject

@property (nonatomic, retain) NSDate* endDate;
@property (nonatomic, retain) NSDate* startDate;

@end
