//
//  MGMAlbumMetadata+Relationships.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumMetadata.h"

@class MGMAlbum;

@interface MGMAlbumMetadata (Relationships)

@property (nonatomic, strong) MGMAlbum* album;

@end
