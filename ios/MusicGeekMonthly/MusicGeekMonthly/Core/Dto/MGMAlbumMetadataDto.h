//
//  MGMAlbumMetadataDto.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMAlbumServiceType.h"

@interface MGMAlbumMetadataDto : NSObject

@property (nonatomic) MGMAlbumServiceType serviceType;
@property (nonatomic, strong) NSString* value;

@end
