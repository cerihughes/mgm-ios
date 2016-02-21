//
//  MGMAppDelegateTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMTestCase.h"

#import <OCHamcrest/OCHamcrest.h>

#import "MGMAppDelegate.h"

@interface MGMAppDelegateTestCase : MGMTestCase

@end

@implementation MGMAppDelegateTestCase

- (void)testTestDetectionWorks
{
    MGMAppDelegate *appDelegate = [[MGMAppDelegate alloc] init];
    assertThatBool([appDelegate isRunningUnitTests], isTrue());
}

@end
