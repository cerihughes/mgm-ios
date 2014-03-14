//
//  MGMNavigationController.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 07/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGMUI;

@interface MGMNavigationController : UINavigationController

- (id) init __unavailable;
- (id) initWithUI:(MGMUI*)ui;

- (void) checkPlayer;

@end
