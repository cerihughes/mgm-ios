//
//  MGMAbstractEventViewController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumViewController.h"

#import "MGMPlaylistDto.h"

@interface MGMAbstractEventViewController : MGMAlbumViewController

@property (weak) id<MGMPlaylistSelectionDelegate> playlistSelectionDelegate;

@property (readonly) MGMEvent* event;
@property (readonly) MGMPlaylistDto* playlist;

- (void) displayEvent:(MGMEvent*)event playlist:(MGMPlaylistDto*)playlist;

#pragma mark -
#pragma mark MGMAlbumViewController

- (void) classicAlbumPressed;
- (void) classicAlbumDetailPressed;
- (void) newlyReleasedAlbumPressed;
- (void) newlyReleasedAlbumDetailPressed;
- (void) playlistPressed;

@end
