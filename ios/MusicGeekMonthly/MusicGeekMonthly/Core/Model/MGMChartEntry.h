//
//  MGMChartEntry.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 12/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "MGMAlbumImageSize.h"

@class MGMAlbum;
@class MGMWeeklyChart;

@interface MGMChartEntry : NSManagedObject

@property (nonatomic, strong) NSNumber* listeners;
@property (nonatomic, strong) NSNumber* rank;
@property (nonatomic, strong) MGMWeeklyChart* weeklyChart;
@property (nonatomic, strong) MGMAlbum* album;

- (NSArray*) bestImageUrlsWithPreferredSize:(MGMAlbumImageSize)preferredSize;

@end
