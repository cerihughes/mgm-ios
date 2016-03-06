//
//  MGMInitialLoadingViewTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 05/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#import "MGMInitialLoadingView.h"

@interface MGMInitialLoadingViewTestCase : MGMSnapshotFullscreenDeviceTestCase

@end

@implementation MGMInitialLoadingViewTestCase

- (void)runTestInFrame:(CGRect)frame
{
    MGMInitialLoadingView *view = [[MGMInitialLoadingView alloc] initWithFrame:frame];
    [view setOperationInProgress:YES];

    [self snapshotView:view];
}

@end
