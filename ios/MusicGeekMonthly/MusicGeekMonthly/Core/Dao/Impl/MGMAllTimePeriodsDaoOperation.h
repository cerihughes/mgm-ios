//
//  MGMAllTimePeriodsDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"

#import "MGMRemoteJsonDataSource.h"

@interface MGMAllTimePeriodsDaoOperation : MGMDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

@end

@interface MGMAllTimePeriodsLocalDataSource : MGMLocalDataSource

@end

@interface MGMAllTimePeriodsRemoteDataSource : MGMRemoteJsonDataSource

@end
