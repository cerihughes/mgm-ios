//
//  MGMDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

@import Foundation;

@class MGMCoreDataAccess;
@class MGMDaoData;
@class MGMLocalDataSource;
@class MGMNextUrlAccess;
@class MGMRemoteDataSource;

typedef void (^DAO_FETCH_COMPLETION) (MGMDaoData*);

@interface MGMDaoOperation : NSObject

@property (readonly) NSUInteger daysBetweenRemoteFetch;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess;

- (void) setReachability:(BOOL)reachability;
- (oneway void) fetchData:(id)key completion:(DAO_FETCH_COMPLETION)completion;

@end

@interface MGMDaoOperation (Protected)

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess*)coreDataAccess;
- (MGMRemoteDataSource*) createRemoteDataSource;

- (NSString*) refreshIdentifierForKey:(id)key;
- (BOOL) needsRefresh:(MGMNextUrlAccess*)nextAccess;

@end
