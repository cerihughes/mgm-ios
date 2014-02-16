//
//  MGMAllEventsDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"

@interface MGMAllEventsDaoOperation : MGMDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

@end

@interface MGMAllEventsLocalDataSource : MGMLocalDataSource

@end

@interface MGMAllEventsRemoteDataSource : MGMRemoteDataSource

@end
