//
//  MGMEventsModalView.h
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@protocol MGMEventsModalViewDelegate <NSObject>

- (void) cancelButtonPressed:(id)sender;

@end

@interface MGMEventsModalView : MGMView

@property (weak) id<MGMEventsModalViewDelegate> delegate;

@property (readonly) UITableView* eventsTable;

@end
