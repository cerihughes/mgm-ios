//
//  MGMDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMCoreDataAccess.h"
#import "MGMDaoData.h"
#import "MGMLocalDataSource.h"
#import "MGMRemoteDataSource.h"

@interface MGMDaoOperation : NSObject

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess localDataSource:(MGMLocalDataSource*)localDataSource remoteDataSource:(MGMRemoteDataSource*)remoteDataSource daysBetweenRemoteFetch:(NSUInteger)daysBetweenRemoteFetch;

- (void) setReachability:(BOOL)reachability;

- (MGMDaoData*) fetchData:(id)key;

@end
