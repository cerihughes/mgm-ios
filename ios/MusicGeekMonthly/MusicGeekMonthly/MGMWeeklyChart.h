//
//  MGMWeeklyChart.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGMChartEntry.h"
#import "MGMCompletion.h"

@interface MGMWeeklyChart : NSManagedObject

@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSDate* endDate;

- (NSOrderedSet*) fetchChartEntries;
- (void) persistChartEntry:(MGMChartEntry*)chartEntry;

@end


