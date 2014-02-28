//
//  MGMPlaylistItemDto.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMImagedEntityDto.h"

@interface MGMPlaylistItemDto : MGMImagedEntityDto

@property (nonatomic, strong) NSString* artist;
@property (nonatomic, strong) NSString* album;
@property (nonatomic, strong) NSString* track;

@end
