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
#import "MGMImageHelper.h"

@interface MGMAlbumViewUtilities : NSObject

- (id) init __unavailable;
- (id) initWithImageHelper:(MGMImageHelper*)imageHelper renderService:(MGMAlbumRenderService*)renderService;

- (MGMAlbumImageSize) preferredImageSizeForViewSize:(CGSize)viewSize;
- (void) displayAlbumDto:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error;
- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error;

@end
