//
//  MGMAbstractEventViewController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumViewController.h"
#import "MGMAbstractEventView.h"

@class MGMEvent;
@class MGMPlaylist;
@protocol MGMPlaylistSelectionDelegate;

@interface MGMAbstractEventViewController<ViewType:MGMAbstractEventView *> : MGMAlbumViewController<ViewType>

@property (nonatomic, strong) ViewType view;

@property (weak) id<MGMPlaylistSelectionDelegate> playlistSelectionDelegate;

@property (readonly) MGMEvent* event;
@property (readonly) MGMPlaylist* playlist;

- (void) displayEvent:(MGMEvent*)event playlist:(MGMPlaylist*)playlist;

#pragma mark -
#pragma mark MGMAlbumViewController

- (void) classicAlbumPressed;
- (void) classicAlbumDetailPressed;
- (void) newlyReleasedAlbumPressed;
- (void) newlyReleasedAlbumDetailPressed;
- (void) playlistPressed;

@end
