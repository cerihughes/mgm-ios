//
//  MGMGroupAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

#define IMAGE_SIZE_SMALL @"small"
#define IMAGE_SIZE_MEDIUM @"medium"
#define IMAGE_SIZE_LARGE @"large"
#define IMAGE_SIZE_EXTRA_LARGE @"extralarge"
#define IMAGE_SIZE_MEGA @"mega"

@interface MGMGroupAlbum : MGMAlbum

@property NSUInteger rank;
@property (strong) NSString* artistMbid;
@property (strong) NSString* albumMbid;
@property (strong) NSString* lastFmUri;
@property (strong) NSDictionary* imageUris;
@property NSUInteger listeners;
@property BOOL searchedLastFmData;
@property BOOL searchedSpotifyData;

@end
