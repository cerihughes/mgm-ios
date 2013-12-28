//
//  MGMDaoFactory.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMCoreDataDao.h"
#import "MGMEventsDao.h"
#import "MGMLastFmDao.h"
#import "MGMReachabilityManager.h"
#import "MGMSettingsDao.h"
#import "MGMSpotifyDao.h"

@interface MGMDaoFactory : NSObject

@property (readonly) MGMCoreDataDao* coreDataDao;
@property (readonly) MGMLastFmDao* lastFmDao;
@property (readonly) MGMSpotifyDao* spotifyDao;
@property (readonly) MGMEventsDao* eventsDao;
@property (readonly) MGMSettingsDao* settingsDao;

- (id) initWithReachabilityManager:(MGMReachabilityManager*)reachabilityManager;

- (MGMAlbumMetadataDao*) metadataDaoForServiceType:(MGMAlbumServiceType)serviceType;

@end
