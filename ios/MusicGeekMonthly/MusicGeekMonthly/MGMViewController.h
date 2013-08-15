//
//  MGMViewController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "UIViewController+MGMAdditions.h"
#import "MGMUI.h"

@interface MGMViewController : UIViewController

@property (weak) MGMUI* ui;

- (void) transitionCompleteWithState:(id)state;

- (void) handleError:(NSError*)error;

@end
