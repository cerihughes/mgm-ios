//
//  MGMAlbumSelectionDelegate.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import UIKit;

@class MGMAlbum;

@protocol MGMAlbumSelectionDelegate <NSObject>

- (void) albumSelected:(MGMAlbum*)album;
- (void) detailSelected:(MGMAlbum*)album sender:(UIViewController*)sender;

@end

@protocol MGMPlaylistSelectionDelegate <NSObject>

- (void) playlistSelected:(NSString*)spotifyPlaylistId;

@end
