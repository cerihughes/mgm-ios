//
//  MGMPlaylistDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 22/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"

#import "MGMRemoteXmlDataSource.h"

@interface MGMPlaylistDaoOperation : MGMDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

@end

@interface MGMPlaylistLocalDataSource : MGMLocalDataSource

@end

@interface MGMPlaylistRemoteDataSource : MGMRemoteXmlDataSource

@end
