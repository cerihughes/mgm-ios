//
//  MGMEventDto.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;

@class MGMAlbumDto;

@interface MGMEventDto : NSObject

@property (nonatomic, strong) NSNumber* eventNumber;
@property (nonatomic, strong) NSDate* eventDate;
@property (nonatomic, strong) NSString* playlistId;
@property (nonatomic, strong) MGMAlbumDto* classicAlbum;
@property (nonatomic, strong) MGMAlbumDto* newlyReleasedAlbum;

@end
