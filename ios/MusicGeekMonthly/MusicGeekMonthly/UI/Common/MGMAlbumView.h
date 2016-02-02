//
//  MGMAlbumView.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 01/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@import Foundation;
@import UIKit;

@class MGMAlbumView;

@protocol MGMAlbumViewDelegate <NSObject>

- (void) albumPressed:(MGMAlbumView*)albumView;
- (void) detailPressed:(MGMAlbumView*)albumView;

@end

@interface MGMAlbumView : MGMView

@property (weak) id<MGMAlbumViewDelegate> delegate;

@property CGFloat alphaOn;
@property NSTimeInterval animationTime;
@property BOOL pressable;

@property (copy) NSString* artistName;
@property (copy) NSString* albumName;
@property NSUInteger rank;
@property NSUInteger listeners;
@property CGFloat score;

@property BOOL activityInProgress;
@property BOOL detailViewShowing;

- (void) renderImageWithNoAnimation:(UIImage*)image;
- (void) renderImage:(UIImage*)image;
- (void) fadeOutAndRenderImage:(UIImage*)image;

@end
