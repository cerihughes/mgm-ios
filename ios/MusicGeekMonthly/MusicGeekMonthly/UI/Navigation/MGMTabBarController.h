//
//  MGMTabBarController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMBackgroundAlbumArtCollection.h"

@class MGMUI;

@interface MGMTabBarController : UITabBarController

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUI:(MGMUI *)ui albumArtCollection:(MGMBackgroundAlbumArtCollection *)albumArtCollection;

@end
