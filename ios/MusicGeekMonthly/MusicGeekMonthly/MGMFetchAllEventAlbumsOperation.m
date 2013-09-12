//
//  MGMFetchAllEventAlbumsOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchAllEventAlbumsOperation.h"

@implementation MGMFetchAllEventAlbumsOperation

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    [self.coreDataDao fetchAllEventAlbums:completion];
}

@end
