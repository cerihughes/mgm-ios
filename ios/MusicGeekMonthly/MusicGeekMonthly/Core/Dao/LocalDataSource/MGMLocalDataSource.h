//
//  MGMLocalDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMCoreDataAccess.h"
#import "MGMLocalData.h"
#import "MGMRemoteData.h"

typedef void (^LOCAL_DATA_PERSIST_COMPLETION) (NSError*);
typedef void (^LOCAL_DATA_FETCH_COMPLETION) (MGMLocalData*);

@interface MGMLocalDataSource : NSObject

@property (readonly) MGMCoreDataAccess* coreDataAccess;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess;

- (oneway void) fetchLocalData:(id)key completion:(LOCAL_DATA_FETCH_COMPLETION)completion;
- (oneway void) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key completion:(LOCAL_DATA_PERSIST_COMPLETION)completion;

@end
