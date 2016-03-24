//
//  MGMExampleAlbumViewController.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMExampleAlbumView.h"
#import "MGMModalView.h"
#import "MGMViewController.h"

@interface MGMExampleAlbumViewController : MGMViewController<MGMModalView<MGMExampleAlbumView *> *>

@end
