//
//  MGMPlayerSelectionView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractPlayerSelectionView.h"

#import "MGMPlayerSelectionMode.h"

@interface MGMPlayerSelectionView : MGMAbstractPlayerSelectionView

@property (nonatomic) MGMPlayerSelectionMode mode;

@end

@interface MGMPlayerSelectionViewPhone : MGMPlayerSelectionView

@end

@interface MGMPlayerSelectionViewPad : MGMPlayerSelectionView

@end
