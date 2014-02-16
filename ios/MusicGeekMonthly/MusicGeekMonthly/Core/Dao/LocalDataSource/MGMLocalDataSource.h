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

@interface MGMLocalDataSource : NSObject

@property (readonly) MGMCoreDataAccess* coreDataAccess;

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (MGMLocalData*) fetchLocalData:(id)key;
- (BOOL) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key error:(NSError**)error;

@end
