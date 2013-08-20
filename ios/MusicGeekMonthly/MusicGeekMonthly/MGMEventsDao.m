//
//  MGMEventsDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsDao.h"

#import "MGMFetchAllEventsOperation.h"

@interface MGMEventsDao ()

@property (strong) MGMFetchAllEventsOperation* fetchAllEventsOperation;

@end

@implementation MGMEventsDao

- (id) initWithCoreDataDao:(MGMCoreDataDao *)coreDataDao
{
    if (self = [super initWithCoreDataDao:coreDataDao])
    {
        self.fetchAllEventsOperation = [[MGMFetchAllEventsOperation alloc] initWithCoreDataDao:coreDataDao daysBetweenUrlFetch:1];
    }
    return self;
}

- (void) fetchAllEvents:(FETCH_MANY_COMPLETION)completion
{
    [self.fetchAllEventsOperation executeWithData:nil completion:completion];
}

@end
