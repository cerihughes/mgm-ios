//
//  MGMAlbumView.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 16/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@class MGMAlbumView;

@protocol MGMAlbumViewDelegate <NSObject>

- (void) albumPressed:(MGMAlbumView*)albumView;

@end

@interface MGMAlbumView : MGMView

@property (weak) id<MGMAlbumViewDelegate> delegate;
@property (strong) UIImage* albumImage;
@property (strong) NSString* artistName;
@property (strong) NSString* albumName;
@property NSUInteger rank;
@property NSUInteger listeners;

@end
