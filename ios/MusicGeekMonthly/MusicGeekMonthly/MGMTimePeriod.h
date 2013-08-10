//
//  MGMTimePerios.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 19/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMTimePeriod : NSObject

@property (strong) NSDate* startDate;
@property (strong) NSDate* endDate;

+ (MGMTimePeriod*) timePeriodWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
- (id) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
