//
//  MGMDaoFetchOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 19/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDao.h"

#import "MGMCompletion.h"
#import "MGMCoreDataDao.h"

@interface MGMDaoFetchOperation : MGMHttpDao

@property (readonly) BOOL hasReachability;

- (id) initWithCoreDataDao:(MGMCoreDataDao*)coreDataDao reachabilityManager:(MGMReachabilityManager*)reachabilityManager daysBetweenUrlFetch:(NSUInteger)daysBetweenUrlFetch;

- (void) executeWithData:(id)data completion:(FETCH_COMPLETION)completion;

#pragma mark -
#pragma mark Override the following

- (NSString*) refreshIdentifierForData:(id)data;
- (NSString*) urlForData:(id)data;
- (NSDictionary*) httpHeaders;
- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion;
- (void) coreDataPersistConvertedData:(id)convertedUrlData withData:(id)data completion:(VOID_COMPLETION)completion;
- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion;

@end
