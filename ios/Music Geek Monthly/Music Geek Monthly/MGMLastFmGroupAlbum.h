//
//  MGMLastFmGroupAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMAGE_SIZE_SMALL @"small"
#define IMAGE_SIZE_MEDIUM @"medium"
#define IMAGE_SIZE_LARGE @"large"
#define IMAGE_SIZE_EXTRA_LARGE @"extralarge"
#define IMAGE_SIZE_MEGA @"mega"

@interface MGMLastFmGroupAlbum : NSObject

@property NSUInteger rank;
@property (strong) NSString* lastFmUri;
@property (strong) NSString* mbid;
@property (strong) NSString* albumName;
@property (strong) NSString* artistName;
@property (strong) NSDictionary* imageUris;
@property NSUInteger listeners;

@end
