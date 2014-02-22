//
//  MGMWeeklyChartView.h
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedView.h"

#import "MGMAlbumGridView.h"

@protocol MGMWeeklyChartViewDelegate <NSObject>

- (void) moreButtonPressed:(id)sender;

@end

@interface MGMWeeklyChartView : MGMTabbedView

@property (weak) id<MGMWeeklyChartViewDelegate> delegate;

@property (readonly) MGMAlbumGridView* albumGridView;

- (void) setTitle:(NSString*)title;

@end
