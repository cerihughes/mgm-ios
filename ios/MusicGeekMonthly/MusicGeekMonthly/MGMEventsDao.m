//
//  MGMEventsDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsDao.h"

#import "MGMFetchAllClassicAlbumsOperation.h"
#import "MGMFetchAllEventsOperation.h"
#import "MGMFetchAllNewlyReleasedAlbumsOperation.h"

@interface MGMEventsDao ()

@property (strong) MGMFetchAllEventsOperation* fetchAllEventsOperation;
@property (strong) MGMFetchAllClassicAlbumsOperation* fetchAllClassicAlbumsOperation;
@property (strong) MGMFetchAllNewlyReleasedAlbumsOperation* fetchAllNewlyReleasedAlbumsOperation;

@end

@implementation MGMEventsDao

- (id) initWithCoreDataDao:(MGMCoreDataDao *)coreDataDao
{
    if (self = [super initWithCoreDataDao:coreDataDao])
    {
        self.fetchAllEventsOperation = [[MGMFetchAllEventsOperation alloc] initWithCoreDataDao:coreDataDao daysBetweenUrlFetch:1];
        self.fetchAllClassicAlbumsOperation = [[MGMFetchAllClassicAlbumsOperation alloc] initWithCoreDataDao:coreDataDao daysBetweenUrlFetch:1];
        self.fetchAllNewlyReleasedAlbumsOperation = [[MGMFetchAllNewlyReleasedAlbumsOperation alloc] initWithCoreDataDao:coreDataDao daysBetweenUrlFetch:1];
    }
    return self;
}

- (void) fetchAllEvents:(FETCH_MANY_COMPLETION)completion
{
    [self.fetchAllEventsOperation executeWithData:nil completion:completion];
}

- (void) fetchAllClassicAlbums:(FETCH_MANY_COMPLETION)completion
{
    [self.fetchAllClassicAlbumsOperation executeWithData:nil completion:completion];
}

- (void) fetchAllNewlyReleasedAlbums:(FETCH_MANY_COMPLETION)completion
{
    [self.fetchAllNewlyReleasedAlbumsOperation executeWithData:nil completion:completion];
}

@end
