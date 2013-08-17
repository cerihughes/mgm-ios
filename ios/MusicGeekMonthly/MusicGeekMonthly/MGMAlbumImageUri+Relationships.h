//
//  MGMAlbumImageUri+Relationships.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumImageUri.h"

@class MGMAlbum;

@interface MGMAlbumImageUri (Relationships)

@property (nonatomic, strong) MGMAlbum* album;

@end

