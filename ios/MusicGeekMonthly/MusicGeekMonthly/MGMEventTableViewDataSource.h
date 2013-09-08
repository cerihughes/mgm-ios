//
//  MGMEventTableViewDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataTableViewDataSource.h"

#import "MGMDaoFactory.h"

@interface MGMEventTableViewDataSource : MGMCoreDataTableViewDataSource

@property (strong) MGMDaoFactory* daoFactory;

@end
