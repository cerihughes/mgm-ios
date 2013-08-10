//
//  MGMAbstractEventController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumViewController.h"
#import "MGMAlbumView.h"

@interface MGMAbstractEventController : MGMAlbumViewController <MGMAlbumViewDelegate>

@property (strong) IBOutlet MGMAlbumView* classicAlbumView;
@property (strong) IBOutlet MGMAlbumView* newlyReleasedAlbumView;

@property (strong) MGMEvent* event;

- (void) displayEvent:(MGMEvent*)event;

@end
