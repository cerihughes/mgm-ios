//
//  MGMWebsiteAlbumMetadataDao.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumMetadataDao.h"

@interface MGMWebsiteAlbumMetadataDao : MGMAlbumMetadataDao

- (id) initWithCoreDataDao:(MGMCoreDataDao *)coreDataDao reachabilityManager:(MGMReachabilityManager *)reachabilityManager albumUrlPattern:(NSString*)albumUrlPattern searchUrlPattern:(NSString*)searchUrlPattern serviceType:(MGMAlbumServiceType)serviceType;

@end
