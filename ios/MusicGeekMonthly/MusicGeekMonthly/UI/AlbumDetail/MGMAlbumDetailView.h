//
//  MGMAlbumDetailView.h
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractPlayerSelectionView.h"

@class MGMAlbumView;

@protocol MGMAlbumDetailViewDelegate <MGMAbstractPlayerSelectionViewDelegate>

- (void) cancelButtonPressed:(id)sender;

@end

@interface MGMAlbumDetailView : MGMAbstractPlayerSelectionView

@property (weak) id<MGMAlbumDetailViewDelegate> delegate;

@property (readonly) MGMAlbumView* albumView;

@end
