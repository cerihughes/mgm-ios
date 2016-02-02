//
//  MGMImagedEntity.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 28/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "MGMAlbumImageSize.h"

@interface MGMImagedEntity : NSManagedObject

@property (nonatomic, strong) NSSet* imageUris;

- (NSArray*) bestImageUrlsWithPreferredSize:(MGMAlbumImageSize)preferredSize;
- (NSArray*) imageUrlsForImageSize:(MGMAlbumImageSize)size;

@end
