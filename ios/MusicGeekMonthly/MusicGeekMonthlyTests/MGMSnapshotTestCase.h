//
//  MGMSnapshotTestCase.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@class MGMDefaultMockContainer;

typedef NS_ENUM(NSUInteger, MGMSnapshotTestCaseDevice)
{
    MGMSnapshotTestCaseDeviceUnknown = 0,
    MGMSnapshotTestCaseDeviceIphone4,
    MGMSnapshotTestCaseDeviceIphone5,
    MGMSnapshotTestCaseDeviceIphone6,
    MGMSnapshotTestCaseDeviceIphone6Plus,
    MGMSnapshotTestCaseDeviceIpad,
    MGMSnapshotTestCaseDeviceIpadPro,
    MGMSnapshotTestCaseDeviceIpadFormSheet
};

@interface MGMSnapshotTestCase : FBSnapshotTestCase

@property (nonatomic, readonly) MGMDefaultMockContainer *mockContainer;

- (CGRect)frameForDevice:(MGMSnapshotTestCaseDevice)device;
- (CGRect)frameForDevice:(MGMSnapshotTestCaseDevice)device landscape:(BOOL)landscape;

- (void)snapshotView:(UIView *)view;
- (void)snapshotView:(UIView *)view withIdentifier:(NSString *)identifier;

@end

@interface MGMSnapshotFullscreenDeviceTestCase : MGMSnapshotTestCase

// Override this method
- (void)runTestInFrame:(CGRect)frame;

@end