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

- (CGRect) fullscreenRect;
- (void) presentViewModally:(UIView*)view sender:(id)sender;
- (void) dismissModalPresentation;
- (BOOL) isPresentingModally;

- (void) transitionCompleteWithState:(id)state;

- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

@end
