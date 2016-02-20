//
//  MGMSnapshotTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

@implementation MGMSnapshotTestCase

- (void)setUp
{
    [super setUp];

//    self.recordMode = YES;
}

typedef struct
{
    CGColorRef color1;
    CGColorRef color2;
} PatternInfo;

static inline CGFloat RandomFloat(void)
{
    return random() / (CGFloat)INT_MAX;
}

static void GetColorComponentsForSeed(NSString *seed, CGFloat scale, CGFloat bias, CGFloat *red, CGFloat *green, CGFloat *blue)
{
    NSUInteger hash = [seed hash];
    srandom((int)hash);
    *red = RandomFloat() * scale + bias;
    *green = RandomFloat() * scale + bias;
    *blue = RandomFloat() * scale + bias;
    srandomdev();
}

UIColor *SPTColorForSeed(NSString *seed, CGFloat bias, CGFloat scale)
{
    CGFloat red, green, blue;
    GetColorComponentsForSeed(seed, scale, bias, &red, &green, &blue);
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

static const CGFloat PatternSize = 16;

static void DrawPattern(void *info, CGContextRef context)
{
    PatternInfo *patternInfo = (PatternInfo *)info;
    const CGFloat halfPatternSize = PatternSize / 2;

    CGRect topLeft = {{ 0, 0 }, { halfPatternSize, halfPatternSize }};
    CGRect topRight = {{ halfPatternSize, 0 }, { halfPatternSize, halfPatternSize }};
    CGRect bottomLeft = {{ 0, halfPatternSize }, { halfPatternSize, halfPatternSize }};
    CGRect bottomRight = {{ halfPatternSize, halfPatternSize }, { halfPatternSize, halfPatternSize }};

    CGContextSetFillColorWithColor(context, patternInfo->color1);
    CGContextFillRect(context, topLeft);
    CGContextFillRect(context, bottomRight);
    CGContextSetFillColorWithColor(context, patternInfo->color2);
    CGContextFillRect(context, topRight);
    CGContextFillRect(context, bottomLeft);
}

- (UIImage *)imageOfSize:(NSUInteger)sizeInPixels withSeed:(NSString *)seed
{
    UIGraphicsBeginImageContextWithOptions((CGSize){ sizeInPixels, sizeInPixels }, YES, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *color1 = SPTColorForSeed(seed, 0.3, 0.2);
    UIColor *color2 = SPTColorForSeed(seed, 0.6, 0.3);
    PatternInfo patternInfo = {
        color1.CGColor,
        color2.CGColor
    };
    CGPatternRef pattern = CGPatternCreate(&patternInfo,
                                           (CGRect){ CGPointZero, (CGSize){ PatternSize, PatternSize }},
                                           CGAffineTransformIdentity,
                                           PatternSize, PatternSize,
                                           kCGPatternTilingNoDistortion,
                                           true,
                                           &(CGPatternCallbacks){ 0, DrawPattern, nil });

    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGContextSetFillPattern(context, pattern, &(CGFloat){ 1.0 });

    CGContextFillRect(context, (CGRect){ CGPointZero, (CGSize){ sizeInPixels, sizeInPixels }});

    CGPatternRelease(pattern);
    CGColorSpaceRelease(patternSpace);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
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
             };
}

@end
