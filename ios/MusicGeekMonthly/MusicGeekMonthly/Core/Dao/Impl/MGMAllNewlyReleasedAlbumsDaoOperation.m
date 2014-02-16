//
//  MGMAllNewlyReleasedAlbumsDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAllNewlyReleasedAlbumsDaoOperation.h"

#import "MGMLastFmConstants.h"
#import "MGMEventDto.h"
#import "MGMRemoteDataSource+Protected.h"

@implementation MGMAllNewlyReleasedAlbumsDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    MGMLocalDataSource* localDataSource = [[MGMAllNewlyReleasedAlbumsLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
    MGMRemoteDataSource* remoteDataSource = [[MGMAllEventsRemoteDataSource alloc] init];
    return [super initWithCoreDataAccess:coreDataAccess localDataSource:localDataSource remoteDataSource:remoteDataSource daysBetweenRemoteFetch:1];
}

@end

@implementation MGMAllNewlyReleasedAlbumsLocalDataSource

- (MGMLocalData*) fetchLocalData:(id)key
{
    MGMLocalData* localData = [[MGMLocalData alloc] init];
    NSError* error = nil;
    localData.data = [self.coreDataAccess fetchAllNewlyReleasedAlbums:&error];
    localData.error = error;
    return localData;
}

@end
