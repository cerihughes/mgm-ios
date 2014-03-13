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

typedef void (^DAO_FETCH_COMPLETION) (MGMDaoData*);

@interface MGMDaoOperation : NSObject

@property (readonly) NSUInteger daysBetweenRemoteFetch;

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (void) setReachability:(BOOL)reachability;
- (oneway void) fetchData:(id)key completion:(DAO_FETCH_COMPLETION)completion;

@end

@interface MGMDaoOperation (Protected)

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess*)coreDataAccess;
- (MGMRemoteDataSource*) createRemoteDataSource;

- (NSString*) refreshIdentifierForKey:(id)key;
- (BOOL) needsRefresh:(MGMNextUrlAccess*)nextAccess;

@end
