//
//  MGMNavigationController.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 07/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

@import UIKit;

@class MGMUI;

@interface MGMNavigationController : UINavigationController

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUI:(MGMUI *)ui;

- (void) checkPlayer;

@end
