//
//  MGMAbstractEventView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMAlbumView.h"

@protocol MGMAbstractEventViewDelegate <NSObject>

- (void) classicAlbumPressed;
- (void) classicAlbumDetailPressed;
- (void) newlyReleasedAlbumPressed;
- (void) newlyReleasedAlbumDetailPressed;

@end

@interface MGMAbstractEventView : MGMView

@property (weak) id<MGMAbstractEventViewDelegate> delegate;

@property (readonly) UILabel* classicAlbumLabel;
@property (readonly) MGMAlbumView* classicAlbumView;
@property (readonly) UILabel* newlyReleasedAlbumLabel;
@property (readonly) MGMAlbumView* newlyReleasedAlbumView;

@end
