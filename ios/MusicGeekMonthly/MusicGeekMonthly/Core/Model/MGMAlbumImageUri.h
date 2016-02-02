//
//  MGMAlbumImageUri.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "MGMAlbumImageSize.h"

@class MGMImagedEntity;

@interface MGMAlbumImageUri : NSManagedObject

@property (nonatomic, strong) NSString* uri;
@property (nonatomic, strong) MGMImagedEntity* imagedEntity;

@property (nonatomic) MGMAlbumImageSize size;

@end
