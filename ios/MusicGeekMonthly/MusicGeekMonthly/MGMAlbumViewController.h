//
//  MGMAlbumViewController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabbedViewController.h"

#import "MGMAlbumSelectionDelegate.h"

@interface MGMAlbumViewController : MGMTabbedViewController

@property (weak) id<MGMAlbumSelectionDelegate> albumSelectionDelegate;

@end
