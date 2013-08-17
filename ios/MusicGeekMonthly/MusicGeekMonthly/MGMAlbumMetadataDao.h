//
//  MGMAlbumMetadataDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDao.h"
#import "MGMAlbum.h"

@interface MGMAlbumMetadataDao : MGMHttpDao

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion;

@end
