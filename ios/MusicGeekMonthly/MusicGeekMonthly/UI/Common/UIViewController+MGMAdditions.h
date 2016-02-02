//
//  UIViewController+MGMAdditions.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 22/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import UIKit;

@class MGMCore;
@class MGMUI;

@interface UIViewController (MGMAdditions)

@property (weak) MGMUI* ui;
@property (readonly) MGMCore* core;

- (void) transitionCompleteWithState:(id)state;

@end
