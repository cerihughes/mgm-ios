//
//  MGMSnapshotTestCaseImageUtilities.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGMAlbumRenderService;
@class MGMImageHelper;

@interface MGMSnapshotTestCaseImageUtilities : NSObject

+ (void)setupAlbumRenderServiceMock:(MGMAlbumRenderService *)albumRenderServiceMock;
+ (void)setupImageHelperMock:(MGMImageHelper *)imageHelperMock toReturnImageOfSize:(NSUInteger)size;

+ (UIImage *)imageOfSize:(NSUInteger)sizeInPixels withSeed:(NSString *)seed;

@end
