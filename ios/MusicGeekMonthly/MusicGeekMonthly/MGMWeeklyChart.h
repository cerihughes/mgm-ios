//
//  MGMWeeklyChart.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MGMTimePeriod.h"
#import "MGMAlbum.h"

@interface MGMWeeklyChart : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *albums;
@property (nonatomic, retain) MGMTimePeriod *timePeriod;

@end

@interface MGMWeeklyChart (AlbumsAccessors)

- (NSMutableSet*)primitiveAlbums;
- (void)setPrimitiveAlbums:(NSMutableSet*)values;

- (void) addAlbumsObject:(MGMAlbum*)value;
- (void) addAlbums:(NSOrderedSet*)values;

@end
