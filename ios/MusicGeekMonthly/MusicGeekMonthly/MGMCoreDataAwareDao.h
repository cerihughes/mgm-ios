//
//  MGMCoreDataAwareDao.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"
#import "MGMCoreDataDao.h"

@interface MGMCoreDataAwareDao : MGMDao

@property (readonly) MGMCoreDataDao* coreDataDao;

- (id) initWithCoreDataDao:(MGMCoreDataDao*)coreDataDao;

@end
