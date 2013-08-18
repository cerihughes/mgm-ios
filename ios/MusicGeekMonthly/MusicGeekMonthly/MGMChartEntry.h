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

@interface MGMChartEntry : NSManagedObject

@property (nonatomic, strong) NSNumber* listeners;
@property (nonatomic, strong) NSNumber* rank;

- (MGMAlbum*) fetchAlbum;
- (void) persistAlbum:(MGMAlbum*)album;

- (NSString*) fetchBestAlbumImageUrl;
- (NSString*) fetchBestTableImageUrl;

@end
