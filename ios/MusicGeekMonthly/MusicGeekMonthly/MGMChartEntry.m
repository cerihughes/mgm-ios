//
//  MGMChartEntry.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMChartEntry.h"

#import "MGMChartEntry+Relationships.h"

@implementation MGMChartEntry

@dynamic listeners;
@dynamic rank;

- (MGMAlbum*) fetchAlbum
{
    __block MGMAlbum* result;
    [self.managedObjectContext performBlockAndWait:^
    {
        result = self.album;
    }];
    return result;
}

- (NSString*) fetchBestAlbumImageUrl
{
    __block NSString* result;
    [self.managedObjectContext performBlockAndWait:^
    {
        result = [self bestAlbumImageUrl];
    }];
    return result;
}

- (NSString*) fetchBestTableImageUrl
{
    __block NSString* result;
    [self.managedObjectContext performBlockAndWait:^
    {
        result = [self bestTableImageUrl];
    }];
    return result;
}

@end
