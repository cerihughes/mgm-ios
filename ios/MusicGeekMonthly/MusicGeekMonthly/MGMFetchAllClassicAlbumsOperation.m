//
//  MGMFetchAllClassicAlbumsOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 11/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchAllClassicAlbumsOperation.h"

@implementation MGMFetchAllClassicAlbumsOperation

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    [self.coreDataDao fetchAllClassicAlbums:completion];
}

@end
