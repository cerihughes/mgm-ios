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
#import "MGMSpotifyDao.h"

@interface MGMDaoFactory : NSObject

@property (strong) MGMCoreDataDao* coreDataDao;
@property (strong) MGMLastFmDao* lastFmDao;
@property (strong) MGMSpotifyDao* spotifyDao;
@property (strong) MGMEventsDao* eventsDao;

- (id) initWithReachabilityManager:(MGMReachabilityManager*)reachabilityManager;

- (MGMAlbumMetadataDao*) metadataDaoForServiceType:(MGMAlbumServiceType)serviceType;

@end
