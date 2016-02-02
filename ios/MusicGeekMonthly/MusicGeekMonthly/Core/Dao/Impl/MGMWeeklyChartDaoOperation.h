//
//  MGMWeeklyChartDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"
#import "MGMLocalDataSource.h"
#import "MGMRemoteDataSource.h"

@import Foundation;

@interface MGMWeeklyChartData : NSObject

@property (strong) NSDate* startDate;
@property (strong) NSDate* endDate;

@end

@interface MGMWeeklyChartDaoOperation : MGMDaoOperation

@end

@interface MGMWeeklyChartLocalDataSource : MGMLocalDataSource

@end

@interface MGMWeeklyChartRemoteDataSource : MGMRemoteDataSource

@end
