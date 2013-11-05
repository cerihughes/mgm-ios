//
//  MGMWeeklyChartView.h
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMWeeklyChartAlbumsView.h"

@protocol MGMWeeklyChartViewDelegate <NSObject>

- (void) moreButtonPressed:(id)sender;

@end

@interface MGMWeeklyChartView : MGMView

@property (weak) id<MGMWeeklyChartViewDelegate> delegate;

@property (readonly) MGMWeeklyChartAlbumsView* albumsView;

- (void) setTitle:(NSString*)title;

@end
