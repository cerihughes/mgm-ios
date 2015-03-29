//
//  MGMAllEventsGoogleSheetDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/03/2015.
//  Copyright (c) 2015 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"

#define ALL_EVENTS_KEY @"ALL_EVENTS_KEY"
#define ALL_CLASSIC_ALBUMS_KEY @"ALL_CLASSIC_ALBUMS_KEY"
#define ALL_NEWLY_RELEASED_ALBUMS_KEY @"ALL_NEWLY_RELEASED_ALBUMS_KEY"
#define ALL_EVENT_ALBUMS_KEY @"ALL_EVENT_ALBUMS_KEY"

@interface MGMAllEventsGoogleSheetDaoOperation : MGMDaoOperation

@end

@interface MGMAllEventsGoogleSheetLocalDataSource : MGMLocalDataSource

@end

@interface MGMAllEventsGoogleSheetRemoteDataSource : MGMRemoteDataSource

@end
