//
//  MGMAlbumDto.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImagedEntityDto.h"

@interface MGMAlbumDto : MGMImagedEntityDto

@property (nonatomic, strong) NSString* albumMbid;
@property (nonatomic, strong) NSString* albumName;
@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSMutableArray* metadata;

@end
