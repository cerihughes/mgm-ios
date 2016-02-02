//
//  MGMEventTableViewDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataTableViewDataSource.h"

@class MGMAlbumRenderService;
@class MGMCoreDataAccess;
@class MGMImageHelper;

@interface MGMEventTableViewDataSource : MGMCoreDataTableViewDataSource

@property (strong) MGMCoreDataAccess* coreDataAccess;
@property (strong) MGMAlbumRenderService* albumRenderService;
@property (strong) MGMImageHelper* imageHelper;

@end
