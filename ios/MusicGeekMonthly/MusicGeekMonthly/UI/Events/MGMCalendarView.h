//
//  MGMCalendarView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@interface MGMCalendarView : MGMView

@property (copy) NSString* month;
@property (copy) NSString* day;

@property (strong) UIFont* monthFont;
@property (strong) UIFont* dayFont;

@end
