//
//  MGMPlaylistItem.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 24/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMImagedEntity.h"

@class MGMPlaylist;

@interface MGMPlaylistItem : MGMImagedEntity

@property (nonatomic, strong) NSString* album;
@property (nonatomic, strong) NSString* artist;
@property (nonatomic, strong) NSString* track;
@property (nonatomic, strong) MGMPlaylist* playlist;

@end
