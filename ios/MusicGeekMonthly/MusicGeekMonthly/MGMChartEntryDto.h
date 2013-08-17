//
//  MGMChartEntryDto.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMAlbumDto.h"

@interface MGMChartEntryDto : NSObject

@property (nonatomic, strong) NSNumber* listeners;
@property (nonatomic, strong) NSNumber* rank;
@property (nonatomic, strong) MGMAlbumDto* album;

@end
