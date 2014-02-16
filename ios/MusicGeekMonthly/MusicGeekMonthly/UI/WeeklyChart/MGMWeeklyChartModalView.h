//
//  MGMWeeklyChartModalView.h
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@protocol MGMWeeklyChartModalViewDelegate <NSObject>

- (void) cancelButtonPressed:(id)sender;

@end

@interface MGMWeeklyChartModalView : MGMView

@property (weak) id<MGMWeeklyChartModalViewDelegate> delegate;

@property (readonly) UITableView* timePeriodTable;

@end
