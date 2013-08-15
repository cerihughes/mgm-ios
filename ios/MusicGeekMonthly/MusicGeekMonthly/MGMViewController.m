//
//  MGMViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMViewController.h"

@interface MGMViewController ()

@end

@implementation MGMViewController

- (void) transitionCompleteWithState:(id)state
{
}

- (void) handleError:(NSError*)error
{
    [self.ui handleError:error];
}

@end
