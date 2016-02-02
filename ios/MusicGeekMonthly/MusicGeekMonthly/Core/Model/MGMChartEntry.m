//
//  MGMChartEntry.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMChartEntry.h"

#import "MGMAlbum.h"

@implementation MGMChartEntry

@dynamic listeners;
@dynamic rank;
@dynamic weeklyChart;
@dynamic album;

- (NSArray*) bestImageUrlsWithPreferredSize:(MGMAlbumImageSize)preferredSize
{
    return [self.album bestImageUrlsWithPreferredSize:preferredSize];
}

@end
