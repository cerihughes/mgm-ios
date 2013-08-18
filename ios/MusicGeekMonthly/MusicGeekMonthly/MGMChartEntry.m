//
//  MGMChartEntry.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMChartEntry.h"

#import "MGMChartEntry+Relationships.h"
#import "NSManagedObjectContext+Debug.h"

@implementation MGMChartEntry

@dynamic listeners;
@dynamic rank;

- (MGMAlbum*) fetchAlbum
{
    __block MGMAlbum* result;
    [self.managedObjectContext debugPerformBlockAndWait:^
    {
        result = self.album;
    }];
    return result;
}

- (void) persistAlbum:(MGMAlbum*)album
{
    [self.managedObjectContext debugPerformBlockAndWait:^
    {
        self.album = album;
    }];
}

- (NSString*) fetchBestAlbumImageUrl
{
    MGMAlbum* album = [self fetchAlbum];
    NSString* uri;
    if (self.rank.intValue == 1 && (uri = [album fetchImageUrlForImageSize:MGMAlbumImageSizeMega]) != nil)
    {
        return uri;
    }

    return [album fetchBestAlbumImageUrl];
}

- (NSString*) fetchBestTableImageUrl
{
    MGMAlbum* album = [self fetchAlbum];
    return [album fetchBestTableImageUrl];
}

@end
