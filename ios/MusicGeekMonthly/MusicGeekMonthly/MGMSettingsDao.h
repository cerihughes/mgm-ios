//
//  MGMSettingsDao.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"

#import "MGMAlbumServiceType.h"

@interface MGMSettingsDao : MGMDao

@property NSUInteger lastCapabilities;
@property MGMAlbumServiceType defaultServiceType;

@end
