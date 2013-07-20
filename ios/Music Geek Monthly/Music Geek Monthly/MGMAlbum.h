//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SPOTIFY_ALBUM_URI_PATTERN @"spotify:album:%@"
#define SPOTIFY_PLAYLIST_URI_PATTERN @"spotify:user:%@:playlist:%@"
#define HTTP_PLAYLIST_URI_PATTERN @"http://open.spotify.com/user/%@/playlist/%@"
#define SPOTIFY_USER_ANDREW_JONES @"fuzzylogic1981"

@interface MGMAlbum : NSObject

@property (strong) NSString* artistName;
@property (strong) NSString* albumName;
@property (strong) NSString* albumMbid;
@property (strong) NSString* spotifyAlbumId;
@property (strong) NSDictionary* imageUris;
@property BOOL searchedLastFmData;

- (NSString*) spotifyAlbumUri;

@end
