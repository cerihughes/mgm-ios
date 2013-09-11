//
//  MGMFetchAllNewlyReleasedAlbumsOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 11/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchAllNewlyReleasedAlbumsOperation.h"

@implementation MGMFetchAllNewlyReleasedAlbumsOperation

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    [self.coreDataDao fetchAllNewlyReleasedAlbums:completion];
}

@end
