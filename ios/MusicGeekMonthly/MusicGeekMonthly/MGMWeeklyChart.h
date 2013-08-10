//
//  MGMWeeklyChart.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMTimePeriod.h"

@interface MGMWeeklyChart : NSObject

@property (strong) MGMTimePeriod* timePeriod;
@property (strong) NSArray* albums;

@end
