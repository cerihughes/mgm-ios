//
//  MGMImageHelper.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 15/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMImageHelper : NSObject

+ (void) asyncImageFromUrl:(NSString*)url completion:(void (^)(UIImage* image))completion;
+ (UIImage*) imageFromUrl:(NSString *)url;

@end
