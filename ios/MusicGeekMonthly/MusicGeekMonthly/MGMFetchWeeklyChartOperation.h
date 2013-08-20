//
//  MGMFetchWeeklyChartOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDaoFetchOperation.h"

@interface MGMFetchWeeklyChartOperationData : NSObject

@property (strong) NSDate* startDate;
@property (strong) NSDate* endDate;

@end

@interface MGMFetchWeeklyChartOperation : MGMDaoFetchOperation

@end
