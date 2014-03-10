//
//  MGMLocalDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMLocalDataSource.h"

@implementation MGMLocalDataSource

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _coreDataAccess = coreDataAccess;
    }
    return self;
}

- (MGMLocalData*) fetchLocalData:(id)key
{
    return nil;
}

- (BOOL) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key error:(NSError**)error
{
    return NO;
}

@end
