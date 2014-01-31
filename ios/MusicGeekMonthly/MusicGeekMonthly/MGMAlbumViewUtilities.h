//
//  MGMAlbumViewUtilities.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 07/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbum.h"
#import "MGMAlbumDto.h"
#import "MGMAlbumView.h"
#import "MGMDaoFactory.h"

@interface MGMAlbumViewUtilities : NSObject

+ (void) displayAlbum:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error;
+ (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName daoFactory:(MGMDaoFactory*)daoFactory error:(NSError**)error;

@end
