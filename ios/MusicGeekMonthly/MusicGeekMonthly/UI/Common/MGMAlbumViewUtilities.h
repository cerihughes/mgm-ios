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
#import "MGMAlbumRenderService.h"
#import "MGMAlbumView.h"

@interface MGMAlbumViewUtilities : NSObject

+ (MGMAlbumImageSize) preferredImageSizeForViewSize:(CGSize)viewSize;
+ (void) displayAlbum:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error;
+ (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName renderService:(MGMAlbumRenderService*)renderService error:(NSError**)error;

@end
