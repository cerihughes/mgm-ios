//
//  MGMEventTableViewDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataTableViewDataSource.h"

#import "MGMCoreDataAccess.h"
#import "MGMAlbumRenderService.h"

@interface MGMEventTableViewDataSource : MGMCoreDataTableViewDataSource

@property (strong) MGMCoreDataAccess* coreDataAccess;
@property (strong) MGMAlbumRenderService* albumRenderService;

@end
