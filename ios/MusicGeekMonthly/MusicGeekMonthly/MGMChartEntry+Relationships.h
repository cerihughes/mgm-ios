//
//  MGMChartEntry+Relationships.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMChartEntry.h"

#import "MGMAlbum.h"

@class MGMWeeklyChart;

@interface MGMChartEntry (Relationships)

@property (nonatomic, strong) MGMWeeklyChart* weeklyChart;
@property (nonatomic, strong) MGMAlbum* album;

- (NSString*) bestAlbumImageUrl;
- (NSString*) bestTableImageUrl;

@end
