//
//  MGMChartEntry.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMChartEntry.h"

@implementation MGMChartEntry

@dynamic listeners;
@dynamic rank;
@dynamic weeklyChart;
@dynamic album;

- (NSString*) bestAlbumImageUrl
{
    NSString* uri;
    if (self.rank.intValue == 1 && (uri = [self.album imageUrlForImageSize:MGMAlbumImageSizeMega]) != nil)
    {
        return uri;
    }

    return [self.album bestAlbumImageUrl];
}

- (NSString*) bestTableImageUrl
{
    return [self.album bestTableImageUrl];
}

@end
