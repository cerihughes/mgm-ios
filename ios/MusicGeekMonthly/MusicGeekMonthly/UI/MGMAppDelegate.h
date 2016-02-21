//
//  MGMAppDelegate.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import UIKit;

@interface MGMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#if DEBUG
// We rely on this working during testing, so add a test for it.
- (BOOL)isRunningUnitTests;
#endif

@end
