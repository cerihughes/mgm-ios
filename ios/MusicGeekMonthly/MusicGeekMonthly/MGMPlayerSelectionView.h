//
//  MGMPlayerSelectionView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMAlbumServiceType.h"
#import "MGMPlayerSelectionMode.h"

@protocol MGMPlayerSelectionViewDelegate <NSObject>

- (void) playerSelectionComplete:(MGMAlbumServiceType)selectedServiceType;

@end

@interface MGMPlayerSelectionView : MGMView

@property (weak) id<MGMPlayerSelectionViewDelegate> delegate;
@property MGMPlayerSelectionMode mode;

- (void) clearServiceTypes;
- (void) addServiceType:(MGMAlbumServiceType)serviceType text:(NSString*)text image:(UIImage*)image available:(BOOL)available;
- (void) setSelectedServiceType:(MGMAlbumServiceType)serviceType;

@end
