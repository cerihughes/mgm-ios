//
//  MGMChartEntry.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGMAlbum.h"
#import "MGMCompletion.h"

@class MGMWeeklyChart;

@interface MGMChartEntry : NSManagedObject

@property (nonatomic, strong) NSNumber* listeners;
@property (nonatomic, strong) NSNumber* rank;
@property (nonatomic, strong) MGMWeeklyChart* weeklyChart;
@property (nonatomic, strong) MGMAlbum* album;

- (NSArray*) bestImageUrlsWithPreferredSize:(MGMAlbumImageSize)preferredSize;
- (NSArray*) bestTableImageUrls;

@end
