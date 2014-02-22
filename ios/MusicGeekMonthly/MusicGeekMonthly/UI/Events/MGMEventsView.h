//
//  MGMEventsView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventView.h"

@protocol MGMEventsViewDelegate <MGMAbstractEventViewDelegate>

- (void) moreButtonPressed:(id)sender;

@end

@interface MGMEventsView : MGMAbstractEventView

@property (weak) id<MGMEventsViewDelegate> delegate;

- (void) setTitle:(NSString*)title;

@end
