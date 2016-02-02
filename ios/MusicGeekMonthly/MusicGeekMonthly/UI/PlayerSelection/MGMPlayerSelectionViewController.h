//
//  MGMPlayerSelectionViewController.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMViewController.h"

#import "MGMAlbumServiceType.h"
#import "MGMPlayerSelectionMode.h"

@protocol MGMPlayerSelectionViewControllerDelegate <NSObject>

- (void) playerSelectionChangedFrom:(MGMAlbumServiceType)oldSelection to:(MGMAlbumServiceType)newSelection;

@end

@interface MGMPlayerSelectionViewController : MGMViewController

@property (weak) id<MGMPlayerSelectionViewControllerDelegate> delegate;

@property MGMPlayerSelectionMode mode;
@property MGMAlbumServiceType existingServiceType;

@end
