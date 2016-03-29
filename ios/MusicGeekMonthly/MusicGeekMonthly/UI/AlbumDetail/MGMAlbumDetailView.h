//
//  MGMAlbumDetailView.h
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractPlayerSelectionView.h"

@class MGMAlbumView;

@interface MGMAlbumDetailView : MGMAbstractPlayerSelectionView

@property (readonly) MGMAlbumView* albumView;

@end

@interface MGMAlbumDetailViewPhone : MGMAlbumDetailView

@end

@interface MGMAlbumDetailViewPad : MGMAlbumDetailView

@end
