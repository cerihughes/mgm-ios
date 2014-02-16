//
//  MGMAllEventAlbumsDaoOperation.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAllEventsDaoOperation.h"

@interface MGMAllEventAlbumsDaoOperation : MGMAllEventsDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

@end

@interface MGMAllEventAlbumsLocalDataSource : MGMAllEventsLocalDataSource

@end
