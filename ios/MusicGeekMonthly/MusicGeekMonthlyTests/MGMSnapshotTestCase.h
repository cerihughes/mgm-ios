//
//  MGMSnapshotTestCase.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

typedef NS_ENUM(NSUInteger, MGMSnapshotTestCaseDevice)
{
    MGMSnapshotTestCaseDeviceUnknown = 0,
    MGMSnapshotTestCaseDeviceIphone4,
    MGMSnapshotTestCaseDeviceIphone5,
    MGMSnapshotTestCaseDeviceIphone6,
    MGMSnapshotTestCaseDeviceIphone6Plus,
    MGMSnapshotTestCaseDeviceIpad,
    MGMSnapshotTestCaseDeviceIpadPro
};

@interface MGMSnapshotTestCase : FBSnapshotTestCase

- (CGRect)frameForDevice:(MGMSnapshotTestCaseDevice)device;
- (CGRect)frameForDevice:(MGMSnapshotTestCaseDevice)device landscape:(BOOL)landscape;
- (UIImage *)imageOfSize:(NSUInteger)sizeInPixels withSeed:(NSString *)seed;

@end
