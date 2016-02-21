//
//  MGMSnapshotTestCaseImageUtilities.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCaseImageUtilities.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "MGMAlbumRenderService.h"
#import "MGMImageHelper.h"

@implementation MGMSnapshotTestCaseImageUtilities

+ (void)setupAlbumRenderServiceMock:(MGMAlbumRenderService *)albumRenderServiceMock
{
    [MKTGivenVoid([albumRenderServiceMock refreshAlbum:anything() completion:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        ALBUM_SERVICE_COMPLETION completion = args[1];
        completion(nil);
        return nil;
    }];
}

+ (void)setupImageHelperMock:(MGMImageHelper *)imageHelperMock toReturnImageOfSize:(NSUInteger)size
{
    [MKTGivenVoid([imageHelperMock imageFromUrls:anything() completion:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        NSArray* urls = args[0];
        IMAGE_HELPER_COMPLETION completion = args[1];
        UIImage *image = [self imageOfSize:size withSeed:urls[0]];
        completion(image, nil);
        return nil;
    }];
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

+ (UIImage *)imageOfSize:(NSUInteger)sizeInPixels withSeed:(NSString *)seed
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

@end
