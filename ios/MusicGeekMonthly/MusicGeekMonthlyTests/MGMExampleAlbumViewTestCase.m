//
//  MGMExampleAlbumViewTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#import "MGMAlbumView.h"
#import "MGMExampleAlbumView.h"
#import "MGMSnapshotTestCaseImageUtilities.h"
#import "MGMUI.h"

@interface MGMExampleAlbumViewTestCase : MGMSnapshotFullscreenDeviceTestCase

@end

@implementation MGMExampleAlbumViewTestCase

- (void)runTestInFrame:(CGRect)frame
{
    Class viewClass = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? [MGMExampleAlbumViewPad class] : [MGMExampleAlbumViewPhone class];
    MGMExampleAlbumView *view = [[viewClass alloc] initWithFrame:frame];
    view.albumView.artistName = @"Sigur Rós";
    view.albumView.albumName = @"Takk...";

    [view layoutIfNeeded]; // To resize correctly...

    [view.albumView renderImageWithNoAnimation:[MGMSnapshotTestCaseImageUtilities imageOfSize:view.albumView.frame.size.width withSeed:view.albumView.artistName]];

    [self snapshotView:view];
}

@end
