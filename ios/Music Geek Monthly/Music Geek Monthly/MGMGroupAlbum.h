//
//  MGMGroupAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

@interface MGMGroupAlbum : MGMAlbum

@property NSUInteger rank;
@property (strong) NSString* artistMbid;
@property (strong) NSString* lastFmUri;
@property NSUInteger listeners;
@property BOOL searchedSpotifyData;

@end
