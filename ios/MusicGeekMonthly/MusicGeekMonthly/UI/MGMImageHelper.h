//
//  MGMImageHelper.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDataSource.h"

@import Foundation;
@import UIKit;

typedef void (^IMAGE_HELPER_COMPLETION) (UIImage *image, NSError *error);

@interface MGMImageHelper : MGMHttpDataSource

- (void) imageFromUrls:(NSArray *)urls completion:(IMAGE_HELPER_COMPLETION)completion;
- (UIImage*) nextDefaultImage;

@end
