//
//  MGMPressabelAlbumView.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 16/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPulsatingAlbumView.h"

@class MGMPressableAlbumView;

@protocol MGMPressableAlbumViewDelegate <NSObject>

- (void) albumPressed:(MGMPressableAlbumView*)albumView;
- (void) detailPressed:(MGMPressableAlbumView*)albumView;

@end

@interface MGMPressableAlbumView : MGMPulsatingAlbumView

@property (weak) id<MGMPressableAlbumViewDelegate> delegate;
@property (strong) NSString* artistName;
@property (strong) NSString* albumName;
@property BOOL activityInProgress;

+ (UILabel*) createLabelWithRect:(CGRect)rect fontName:(NSString*)fontName fontSize:(CGFloat)fontSize;

@end
