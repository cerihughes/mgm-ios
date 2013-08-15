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

- (MGMEvent*) latestEvent:(NSError**)error;
- (NSArray*) events:(NSError**)error;

@end
