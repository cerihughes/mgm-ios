//
//  MGMWeeklyChart+Relationships.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChart.h"

#import "MGMChartEntry.h"

@interface MGMWeeklyChart (Relationships)

@property (nonatomic, strong) NSOrderedSet* chartEntries;

@end

@interface MGMWeeklyChart (ChartEntriesAccessors)

- (NSMutableOrderedSet*)primitiveChartEntries;
- (void) addChartEntriesObject:(MGMChartEntry*)value;

@end
