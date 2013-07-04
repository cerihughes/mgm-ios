//
//  MGMEvent.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMAlbum.h"

@interface MGMEvent : NSObject

@property NSUInteger eventNumber;
@property (strong) NSDate* eventDate;
@property (strong) NSString* spotifyPlaylistId;
@property (strong) MGMAlbum* classicAlbum;
@property (strong) MGMAlbum* newlyReleasedAlbum;

- (NSString*) spotifyPlaylistUrl;
- (NSString*) spotifyHttpUrl;

@end
