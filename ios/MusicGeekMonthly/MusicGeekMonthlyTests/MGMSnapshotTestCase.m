//
//  MGMSnapshotTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#import <objc/runtime.h>

#import "MGMDefaultMockContainer.h"
#import "MGMTestCaseUtilities.h"

@interface MGMSnapshotTestCase ()

@property (nonatomic, strong) MGMTestCaseUtilities *utilities;

@end

@implementation MGMSnapshotTestCase

- (void)setUp
{
    [super setUp];

//    self.recordMode = YES;

    _mockContainer = [[MGMDefaultMockContainer alloc] init];
    _utilities = [[MGMTestCaseUtilities alloc] initWithTestCase:self parentTestClass:[MGMSnapshotTestCase class]];
}

- (void)tearDown
{
    [self.mockContainer removeAllMockObjects];
    [self.utilities nillifyAllTestCaseIvars];

    _mockContainer = nil;
    _utilities = nil;

    [super tearDown];
}

- (UIUserInterfaceIdiom)idiomForDevice:(MGMSnapshotTestCaseDevice)device
{
    if (device == MGMSnapshotTestCaseDeviceIpad || device == MGMSnapshotTestCaseDeviceIpadPro || device == MGMSnapshotTestCaseDeviceIpadFormSheet) {
        return UIUserInterfaceIdiomPad;
    }
    return UIUserInterfaceIdiomPhone;
}

- (CGRect)frameForDevice:(MGMSnapshotTestCaseDevice)device
{
    return [self frameForDevice:device landscape:NO];
}

- (CGRect)frameForDevice:(MGMSnapshotTestCaseDevice)device landscape:(BOOL)landscape
{
    int widthIndex = landscape ? 1 : 0;
    int heightIndex = 1 - widthIndex;
    NSArray *dimensions = [self screenDimensionsForDevice:device];
    NSNumber *width = dimensions[widthIndex];
    NSNumber *height = dimensions[heightIndex];
    return CGRectMake(0, 0, width.floatValue, height.floatValue);
}

- (NSArray *)screenDimensionsForDevice:(MGMSnapshotTestCaseDevice)device
{
    return [self screenDimensions][@(device)];
}

- (NSDictionary *)screenDimensions
{
    return @{
             @(MGMSnapshotTestCaseDeviceIphone4) : @[@320, @480],
             @(MGMSnapshotTestCaseDeviceIphone5) : @[@320, @568],
             @(MGMSnapshotTestCaseDeviceIphone6) : @[@375, @667],
             @(MGMSnapshotTestCaseDeviceIphone6Plus) : @[@414, @736],
             @(MGMSnapshotTestCaseDeviceIpad) : @[@768, @1024],
             @(MGMSnapshotTestCaseDeviceIpadPro) : @[@1024, @1366],
             @(MGMSnapshotTestCaseDeviceIpadFormSheet) : @[@540, @620],
             };
}

- (void)snapshotView:(UIView *)view
{
    [self snapshotView:view withIdentifier:nil];
}

- (void)snapshotView:(UIView *)view withIdentifier:(NSString *)identifier
{
    [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate date] dateByAddingTimeInterval:0.1]];
    FBSnapshotVerifyView(view, identifier);
}

@end

@implementation MGMSnapshotFullscreenDeviceTestCase

- (void)swizzleInstanceMethodSelector:(SEL)selector
                            fromClass:(Class)fromClass
                            withBlock:(id)swizzledMethodBlock
                             forBlock:(dispatch_block_t)block
{
    Method instanceMethod = class_getInstanceMethod(fromClass, selector);

    IMP originalImplementation = method_getImplementation(instanceMethod);
    IMP swizzledImplementation = imp_implementationWithBlock(swizzledMethodBlock);

    method_setImplementation(instanceMethod, swizzledImplementation);
    block();
    method_setImplementation(instanceMethod, originalImplementation);
}

- (void)useDevice:(MGMSnapshotTestCaseDevice)device forBlock:(dispatch_block_t)block
{
    UIUserInterfaceIdiom idiom = [self idiomForDevice:device];
    CGRect frame = [self frameForDevice:device];
    [self swizzleInstanceMethodSelector:@selector(userInterfaceIdiom) fromClass:[UIDevice class] withBlock:^UIUserInterfaceIdiom{
        return idiom;
    } forBlock:^{
        [self swizzleInstanceMethodSelector:@selector(bounds) fromClass:[UIScreen class] withBlock:^CGRect{
            return frame;
        } forBlock:block];
    }];
}

- (void)testIphone4
{
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone4];
}

- (void)testIphone5
{
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone5];
}

- (void)testIphone6
{
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone6];
}

- (void)testIphone6Plus
{
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIphone6Plus];
}

- (void)testIpad
{
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIpad];
}

- (void)testIpadPro
{
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIpadPro];
}

- (void)testIpadFormSheet
{
    [self runTestOnDevice:MGMSnapshotTestCaseDeviceIpadFormSheet];
}

- (void)runTestOnDevice:(MGMSnapshotTestCaseDevice)device
{
    CGRect frame = [self frameForDevice:device];
    [self useDevice:device forBlock:^{
        [self runTestInFrame:frame];
    }];
}

- (void)runTestInFrame:(CGRect)frame
{
    // OVERRIDE
}

@end
