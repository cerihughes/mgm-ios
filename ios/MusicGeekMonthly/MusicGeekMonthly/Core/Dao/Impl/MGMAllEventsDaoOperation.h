//
//  MGMAllEventsDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"

#import "MGMRemoteJsonDataSource.h"

#define ALL_EVENTS_KEY @"ALL_EVENTS_KEY"
#define ALL_CLASSIC_ALBUMS_KEY @"ALL_CLASSIC_ALBUMS_KEY"
#define ALL_NEWLY_RELEASED_ALBUMS_KEY @"ALL_NEWLY_RELEASED_ALBUMS_KEY"
#define ALL_EVENT_ALBUMS_KEY @"ALL_EVENT_ALBUMS_KEY"

@interface MGMAllEventsDaoOperation : MGMDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

@end

@interface MGMAllEventsLocalDataSource : MGMLocalDataSource

@end

@interface MGMAllEventsRemoteDataSource : MGMRemoteJsonDataSource

@end
