//
//  MGMAllTimePeriodsDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"
#import "MGMLocalDataSource.h"
#import "MGMRemoteDataSource.h"

@interface MGMAllTimePeriodsDaoOperation : MGMDaoOperation

@end

@interface MGMAllTimePeriodsLocalDataSource : MGMLocalDataSource

@end

@interface MGMAllTimePeriodsRemoteDataSource : MGMRemoteDataSource

@end
