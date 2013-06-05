//
//  MGMLastFmDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMLastFmGroupAlbum.h"

@interface MGMLastFmDao : NSObject

- (NSArray*) topWeeklyAlbums;
- (void) updateAlbumInfo:(MGMLastFmGroupAlbum*)album;

@end
