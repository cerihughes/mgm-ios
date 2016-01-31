//
//  MGMWebsitePlayerService.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumPlayerService.h"

@interface MGMWebsitePlayerService : MGMAlbumPlayerService

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess NS_UNAVAILABLE;
- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess
                           serviceType:(MGMAlbumServiceType)serviceType NS_UNAVAILABLE;

- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess
                           serviceType:(MGMAlbumServiceType)serviceType
                       albumUrlPattern:(NSString *)albumUrlPattern
                      searchUrlPattern:(NSString *)searchUrlPattern;

@end
