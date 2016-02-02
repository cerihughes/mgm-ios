//
//  MGMViewController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import UIKit;

@class MGMAlbum;
@class MGMAlbumView;
@class MGMUI;

typedef void (^ALBUM_DISPLAY_COMPLETION) (NSError*);

@interface MGMViewController : UIViewController

@property (weak) MGMUI* ui;
@property (readonly) BOOL ipad;
@property (readonly) CGFloat screenScale;

- (CGRect) fullscreenRect;
- (void) presentViewModally:(UIView*)view sender:(id)sender;
- (void) dismissModalPresentation:(UIView *)view;
- (BOOL) isPresentingModally:(UIView *)view;

- (void) transitionCompleteWithState:(id)state;

- (void) showError:(NSError*)error;
- (void) logError:(NSError*)error;

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView completion:(ALBUM_DISPLAY_COMPLETION)completion;
- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView rank:(NSUInteger)rank completion:(ALBUM_DISPLAY_COMPLETION)completion;
- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView rank:(NSUInteger)rank listeners:(NSUInteger)listeners completion:(ALBUM_DISPLAY_COMPLETION)completion;
- (void) displayAlbumImages:(NSArray*)albumArtUrls inAlbumView:(MGMAlbumView*)albumView completion:(ALBUM_DISPLAY_COMPLETION)completion;

@end
