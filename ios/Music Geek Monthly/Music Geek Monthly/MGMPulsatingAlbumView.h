//
//  MGMPulsatingAlbumView.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 24/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@interface MGMPulsatingAlbumView : MGMView

@property CGFloat alphaOff;
@property CGFloat alphaOn;
@property NSTimeInterval animationTime;

- (void) renderImageWithNoAnimation:(UIImage*)image;
- (void) renderImage:(UIImage*)image;
- (void) renderImage:(UIImage*)image afterDelay:(NSTimeInterval)delay;

@end
