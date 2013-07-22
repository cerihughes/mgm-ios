//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define METADATA_KEY_LASTFM @"lastFm"
#define METADATA_KEY_SPOTIFY @"spotify"
#define METADATA_KEY_WIKIPEDIA @"wikipedia"
#define METADATA_KEY_YOUTUBE @"youtube"

@interface MGMAlbum : NSObject

@property (strong) NSString* artistName;
@property (strong) NSString* albumName;
@property (strong) NSString* albumMbid;
@property (strong) NSDictionary* metadata;
@property (strong) NSDictionary* imageUris;
@property BOOL searchedLastFmData;

- (NSString*) lastFmUri;
- (NSString*) spotifyUri;
- (NSString*) wikipediaUri;
- (NSString*) youTubeUri;

@end
