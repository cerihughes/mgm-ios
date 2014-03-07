//
//  MGMTabBarController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGMUI;

@interface MGMTabBarController : UITabBarController

- (id) init __unavailable;
- (id) initWithUI:(MGMUI*)ui;

- (void) startRendering;

@end
