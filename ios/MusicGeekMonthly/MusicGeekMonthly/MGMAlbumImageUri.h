//
//  MGMAlbumImageUri.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum
{
    MGMAlbumImageSizeNone = 0,
    MGMAlbumImageSizeSmall = 1,
    MGMAlbumImageSizeMedium = 2,
    MGMAlbumImageSizeLarge = 3,
    MGMAlbumImageSizeExtraLarge = 4,
    MGMAlbumImageSizeMega = 5
}
MGMAlbumImageSize;

@class MGMAlbum;

@interface MGMAlbumImageUri : NSManagedObject

@property (nonatomic, strong) NSString* uri;
@property (nonatomic, strong) MGMAlbum* album;

@property (nonatomic) MGMAlbumImageSize size;

@end
