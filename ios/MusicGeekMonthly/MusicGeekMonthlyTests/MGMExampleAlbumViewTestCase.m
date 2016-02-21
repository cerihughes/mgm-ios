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

@interface MGMExampleAlbumViewTestCase : MGMSnapshotFullscreenDeviceTestCase

@end

@implementation MGMExampleAlbumViewTestCase

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
