//
//  MGMEvent+Relationships.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEvent.h"

#import "MGMAlbum.h"

@interface MGMEvent (Relationships)

@property (nonatomic, strong) MGMAlbum* classicAlbum;
@property (nonatomic, strong) MGMAlbum* newlyReleasedAlbum;

@end
