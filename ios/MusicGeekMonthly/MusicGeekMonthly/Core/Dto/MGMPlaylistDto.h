//
//  MGMPlaylistDto.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMPlaylistDto : NSObject

@property (nonatomic, strong) NSString* spotifyPlaylistId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableArray* playlistItems;

@end
