//
//  MGMPlaylistDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 22/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"
#import "MGMLocalDataSource.h"
#import "MGMRemoteDataSource.h"

@interface MGMPlaylistDaoOperation : MGMDaoOperation

@end

@interface MGMPlaylistLocalDataSource : MGMLocalDataSource

@end

@interface MGMPlaylistRemoteDataSource : MGMRemoteDataSource

@end
