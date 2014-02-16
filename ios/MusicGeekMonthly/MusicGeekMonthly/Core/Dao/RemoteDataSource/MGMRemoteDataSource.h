//
//  MGMRemoteDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMHttpDataSource.h"

#import "MGMRemoteData.h"

@interface MGMRemoteDataSource : MGMHttpDataSource

- (MGMRemoteData*) fetchRemoteData:(id)key;

@end
