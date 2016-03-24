//
//  MGMAlbumDetailViewController.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 25/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailView.h"
#import "MGMModalView.h"
#import "MGMViewController.h"

@import CoreData;

@interface MGMAlbumDetailViewController : MGMViewController<MGMModalView<MGMAlbumDetailView *> *>

@property (strong) NSManagedObjectID* albumMoid;

@end
