//
//  MGMAlbumMetadata.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import CoreData;

@class MGMAlbum;

#import "MGMAlbumServiceType.h"

@class MGMAlbum;

@interface MGMAlbumMetadata : NSManagedObject

@property (nonatomic, strong) NSString* value;
@property (nonatomic, strong) MGMAlbum* album;

@property (nonatomic) MGMAlbumServiceType serviceType;

@end
