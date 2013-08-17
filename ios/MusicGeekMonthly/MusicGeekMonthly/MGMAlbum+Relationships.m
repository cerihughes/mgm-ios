//
//  MGMAlbum+Relationships.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum+Relationships.h"

@implementation MGMAlbum (Relationships)

@dynamic imageUris;
@dynamic metadata;

- (NSString*) imageUrlForImageSize:(MGMAlbumImageSize)size
{
    for (MGMAlbumImageUri* imageUri in self.imageUris)
    {
        if (imageUri.size == size)
        {
            return imageUri.uri;
        }
    }
    return nil;
}

- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType
{
    for (MGMAlbumMetadata* metadata in self.metadata)
    {
        if (metadata.serviceType == serviceType)
        {
            return metadata.value;
        }
    }
    return nil;
}

- (NSString*) bestImageWithPreferences:(MGMAlbumImageSize[5])sizes
{
    for (NSUInteger i = 0; i < 5; i++)
    {
        NSString* uri = [self imageUrlForImageSize:sizes[i]];
        if (uri)
        {
            return uri;
        }
    }
    return nil;
}

- (NSString*) bestAlbumImageUrl
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSizeExtraLarge, MGMAlbumImageSizeMega, MGMAlbumImageSizeLarge, MGMAlbumImageSizeMedium, MGMAlbumImageSizeSmall};
    return [self bestImageWithPreferences:sizes];
}

- (NSString*) bestTableImageUrl
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSizeSmall, MGMAlbumImageSizeMedium, MGMAlbumImageSizeLarge, MGMAlbumImageSizeExtraLarge, MGMAlbumImageSizeMega};
    return [self bestImageWithPreferences:sizes];
}

@end
