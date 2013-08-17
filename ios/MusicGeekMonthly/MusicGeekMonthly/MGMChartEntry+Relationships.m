//
//  MGMChartEntry+Relationships.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMChartEntry+Relationships.h"

#import "MGMAlbum+Relationships.h"
#import "MGMAlbumImageSize.h"

@implementation MGMChartEntry (Relationships)

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
