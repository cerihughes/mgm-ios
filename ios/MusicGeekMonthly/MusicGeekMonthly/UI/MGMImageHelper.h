//
//  MGMImageHelper.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDataSource.h"

@interface MGMImageHelper : MGMHttpDataSource

- (void) imageFromUrls:(NSArray *)urls completion:(void (^)(UIImage*, NSError*))completion;
- (UIImage*) nextDefaultImage;

@end
