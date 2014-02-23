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

- (void) setAlbumCount:(NSUInteger)albumCount detailViewShowing:(BOOL)detailViewShowing;
- (void) setAlbumFrame:(CGRect)frame forRank:(NSUInteger)rank;
- (MGMAlbumView*) albumViewForRank:(NSUInteger)rank;
- (void) setActivityInProgressForAllRanks:(BOOL)inProgress;

@end
