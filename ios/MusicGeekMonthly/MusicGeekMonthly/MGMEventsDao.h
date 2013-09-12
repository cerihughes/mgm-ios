//
//  MGMEventsDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDao.h"
#import "MGMEvent.h"

@interface MGMEventsDao : MGMHttpDao

- (void) fetchAllEvents:(FETCH_MANY_COMPLETION)completion;
- (void) fetchAllClassicAlbums:(FETCH_MANY_COMPLETION)completion;
- (void) fetchAllNewlyReleasedAlbums:(FETCH_MANY_COMPLETION)completion;
- (void) fetchAllEventAlbums:(FETCH_MANY_COMPLETION)completion;

@end
