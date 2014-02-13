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

- (NSArray*) bestAlbumImageUrls
{
    NSArray* urls;
    if (self.rank.intValue == 1 && (urls = [self.album imageUrlsForImageSize:MGMAlbumImageSize512]) != nil)
    {
        return urls;
    }

    return [self.album bestAlbumImageUrls];
}

- (NSArray*) bestTableImageUrls
{
    return [self.album bestTableImageUrls];
}

@end
