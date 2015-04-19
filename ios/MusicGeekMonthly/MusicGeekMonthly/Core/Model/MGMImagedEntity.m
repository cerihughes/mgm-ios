//
//  MGMImagedEntity.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 28/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMImagedEntity.h"

@implementation MGMImagedEntity

@dynamic imageUris;

- (NSArray*) bestImagesWithPreferences:(MGMAlbumImageSize *)sizes count:(NSUInteger)count
{
    NSMutableArray* array = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++)
    {
        [array addObjectsFromArray:[self imageUrlsForImageSize:sizes[i]]];
    }
    return [array copy];
}

- (NSArray*) bestImageUrlsWithPreferredSize:(MGMAlbumImageSize)preferredSize
{
    MGMAlbumImageSize sizes[6] = {preferredSize, MGMAlbumImageSize128, MGMAlbumImageSize256, MGMAlbumImageSize512, MGMAlbumImageSize64, MGMAlbumImageSize32};
    return [self bestImagesWithPreferences:sizes count:6];
}

- (NSArray*) imageUrlsForImageSize:(MGMAlbumImageSize)size
{
    NSMutableArray* array = [NSMutableArray array];
    for (MGMAlbumImageUri* uri in self.imageUris)
    {
        if (uri.size == size)
        {
            [array addObject:uri.uri];
        }
    }
    return [array copy];
}

@end
