//
//  MGMWeeklyChartAlbumsView.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 17/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMAlbumView.h"

@protocol MGMAlbumGridViewDelegate <NSObject>

- (void) albumPressedWithRank:(NSUInteger)rank;
- (void) detailPressedWithRank:(NSUInteger)rank;

@end

@interface MGMAlbumGridView : MGMView

@property (weak) id<MGMAlbumGridViewDelegate> delegate;

- (void) setAlbumCount:(NSUInteger)albumCount;
- (void) setAlbumFrame:(CGRect)frame forRank:(NSUInteger)rank;
- (MGMAlbumView*) albumViewForRank:(NSUInteger)rank;
- (void) setActivityInProgressForAllRanks:(BOOL)inProgress;
- (void) setActivityInProgress:(BOOL)inProgress forRank:(NSUInteger)rank;
- (void) setAlbumImage:(UIImage*)albumImage artistName:(NSString*)artistName albumName:(NSString*)albumName rank:(NSUInteger)rank listeners:(NSUInteger)listeners score:(CGFloat)score;

@end
