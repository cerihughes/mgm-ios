//
//  MGMSettingsDao.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbumServiceType.h"

@interface MGMSettingsDao : NSObject

@property NSUInteger lastCapabilities;
@property MGMAlbumServiceType defaultServiceType;

@end
