//
//  MGMCoreDataAwareDao.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataAwareDao.h"

@interface MGMCoreDataAwareDao ()

@property (strong) MGMCoreDataDao* internalCoreDataDao;

@end

@implementation MGMCoreDataAwareDao

- (id) initWithCoreDataDao:(MGMCoreDataDao*)coreDataDao
{
    if (self = [super init])
    {
        self.internalCoreDataDao = coreDataDao;
    }
    return self;
}

- (MGMCoreDataDao*) coreDataDao
{
    return self.internalCoreDataDao;
}

@end
