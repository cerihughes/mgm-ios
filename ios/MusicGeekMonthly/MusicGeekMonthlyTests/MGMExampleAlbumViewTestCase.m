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
#import "MGMUI.h"

@interface MGMExampleAlbumViewTestCase : MGMSnapshotTestCase

@end

@implementation MGMExampleAlbumViewTestCase

- (void)testIphone4
{
    [MGMUI setIpad:NO];
    [MGMView setScreenSize:MGMViewScreenSizeiPhone480];
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone4];
}

- (void)testIphone5
{
    [MGMUI setIpad:NO];
    [MGMView setScreenSize:MGMViewScreenSizeiPhone576];
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone5];
}

- (void)testIphone6
{
    [MGMUI setIpad:NO];
    [MGMView setScreenSize:MGMViewScreenSizeiPhone576];
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone6];
}

- (void)testIphone6Plus
{
    [MGMUI setIpad:NO];
    [MGMView setScreenSize:MGMViewScreenSizeiPhone576];
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone6Plus];
}

- (void)testIpadFormSheet
{
    [MGMUI setIpad:YES];
    [MGMView setScreenSize:MGMViewScreenSizeiPad];
    [self runTestInFrame:CGRectMake(0, 0, 540, 620)];
}

- (void)runTestOnDevice:(MGMSnapshotTestCaseDevice)device
{
    CGRect frame = [self frameForDevice:device];
    [self runTestInFrame:frame];
}

- (void)runTestInFrame:(CGRect)frame
{
    MGMExampleAlbumView *view = [[MGMExampleAlbumView alloc] initWithFrame:frame];
    view.albumView.artistName = @"Sigur Rós";
    view.albumView.albumName = @"Takk...";

    [view layoutIfNeeded]; // To resize correctly...

    [view.albumView renderImageWithNoAnimation:[self imageOfSize:view.albumView.frame.size.width withSeed:view.albumView.artistName]];

    FBSnapshotVerifyView(view, nil);
}

@end
