//
//  MGMAlbumsView.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 17/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@protocol MGMAlbumsViewDelegate <NSObject>

- (void) albumPressedWithRank:(NSUInteger)rank;

@end

@interface MGMAlbumsView : MGMView

@property (weak) id<MGMAlbumsViewDelegate> delegate;

- (void) setupAlbumFrame:(CGRect)frame forRank:(NSUInteger)rank;
- (void) setActivityInProgress:(BOOL)inProgress forRank:(NSUInteger)rank;
- (void) setAlbumImage:(UIImage*)albumImage artistName:(NSString*)artistName albumName:(NSString*)albumName rank:(NSUInteger)rank listeners:(NSUInteger)listeners;
- (void) setAlbumImage:(UIImage*)albumImage atRank:(NSUInteger)rank;

@end
