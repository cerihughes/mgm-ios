//
//  MGMGroupAlbums.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 19/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMTimePeriod.h"

@interface MGMGroupAlbums : NSObject

@property (strong) MGMTimePeriod* timePeriod;
@property (strong) NSArray* albums;

@end
