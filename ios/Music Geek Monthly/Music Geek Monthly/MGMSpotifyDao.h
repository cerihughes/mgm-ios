//
//  MGMSpotifyDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"
#import "MGMGroupAlbum.h"

@interface MGMSpotifyDao : MGMDao

- (void) updateAlbumInfo:(MGMGroupAlbum*)album;

@end
