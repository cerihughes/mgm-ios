//
//  UIViewController+MGMAdditions.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 22/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "UIViewController+MGMAdditions.h"

#import "MGMCore.h"
#import "MGMUI.h"

@implementation UIViewController (MGMAdditions)

@dynamic ui;

- (MGMCore*) core
{
    return self.ui.core;
}

- (void) transitionCompleteWithState:(id)state
{
}

@end
