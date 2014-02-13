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

- (NSArray*) bestAlbumImageUrlsWithPreferredSize:(MGMAlbumImageSize)preferredSize
{
    return [self.album bestAlbumImageUrlsWithPreferredSize:preferredSize];
}

- (NSArray*) bestTableImageUrls
{
    return [self.album bestTableImageUrls];
}

@end
