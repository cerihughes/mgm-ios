//
//  MGMAlbumMetadataDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDao.h"

#import "MGMAlbum.h"
#import "MGMAlbumServiceType.h"

@interface MGMAlbumMetadataDao : MGMHttpDao

@property (readonly) MGMAlbumServiceType serviceType;

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(FETCH_COMPLETION)completion;
- (NSString*) serviceAvailabilityUrl;
- (NSString*) urlForAlbum:(MGMAlbum*)album;

@end
