//
//  MGMAbstractPlayerSelectionView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/12/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@import Foundation;
@import UIKit;

#import "MGMAlbumServiceType.h"

@class MGMPlayerGroupView;

@protocol MGMAbstractPlayerSelectionViewDelegate <NSObject>

- (void) playerSelectionComplete:(MGMAlbumServiceType)selectedServiceType;

@end

@interface MGMAbstractPlayerSelectionView : MGMView

@property (weak) id<MGMAbstractPlayerSelectionViewDelegate> delegate;
@property (readonly) MGMPlayerGroupView* groupView;

- (void) clearServiceTypes;
- (void) addServiceType:(MGMAlbumServiceType)serviceType text:(NSString*)text image:(UIImage*)image available:(BOOL)available;
- (void) setSelectedServiceType:(MGMAlbumServiceType)serviceType;

@end
