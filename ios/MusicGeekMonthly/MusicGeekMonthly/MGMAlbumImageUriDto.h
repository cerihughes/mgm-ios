//
//  MGMAlbumImageUriDto.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMAlbumImageSize.h"

@interface MGMAlbumImageUriDto : NSObject

@property (nonatomic) MGMAlbumImageSize size;
@property (nonatomic, strong) NSString* uri;

@end
