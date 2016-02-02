//
//  MGMTimePeriod.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 19/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "MGMRenderable.h"

@interface MGMTimePeriod : NSManagedObject<MGMRenderable>

@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSDate* endDate;

@property (readonly) NSString* groupHeader;
@property (readonly) NSString* groupValue;

@end
