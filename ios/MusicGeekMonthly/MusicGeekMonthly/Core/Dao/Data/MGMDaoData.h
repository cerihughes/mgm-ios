//
//  MGMDaoData.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMData.h"

@import Foundation;

@class MGMLocalData;

@interface MGMDaoData : MGMData

@property BOOL isNew;

+ (MGMDaoData*) dataWithError:(NSError*)error;
+ (MGMDaoData*) dataWithLocalData:(MGMLocalData*)localData isNew:(BOOL)isNew;

@end
