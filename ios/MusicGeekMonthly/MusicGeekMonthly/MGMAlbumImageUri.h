//
//  MGMAlbumImageUri.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MGMAlbumImageSize.h"

@interface MGMAlbumImageUri : NSManagedObject

@property (nonatomic, strong) NSString* uri;

@property (nonatomic) MGMAlbumImageSize size;

@end
