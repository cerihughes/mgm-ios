//
//  MGMAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

@interface MGMAlbum ()

@property (nonatomic, strong) NSNumber* searchedServiceTypesObject;

@end

@implementation MGMAlbum

@dynamic albumMbid;
@dynamic albumName;
@dynamic artistName;
@dynamic score;
@dynamic searchedServiceTypesObject;
@dynamic imageUris;
@dynamic metadata;

- (NSUInteger) searchedServiceTypes
{
    return [self.searchedServiceTypesObject integerValue];
}

- (void) setSearchedServiceTypes:(NSUInteger)searchedServiceTypes
{
    self.searchedServiceTypesObject = [NSNumber numberWithInteger:searchedServiceTypes];
}

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType
{
    return (self.searchedServiceTypes & serviceType) == serviceType;
}

- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType
{
    self.searchedServiceTypes |= serviceType;
}

- (NSArray*) bestImagesWithPreferences:(MGMAlbumImageSize[5])sizes
{
    NSMutableArray* array = [NSMutableArray array];
    for (NSUInteger i = 0; i < 5; i++)
    {
        [array addObjectsFromArray:[self imageUrlsForImageSize:sizes[i]]];
    }
    return [array copy];
}

- (NSArray*) bestAlbumImageUrls
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSize128, MGMAlbumImageSize256, MGMAlbumImageSize512, MGMAlbumImageSize64, MGMAlbumImageSize32};
    return [self bestImagesWithPreferences:sizes];
}

- (NSArray*) bestTableImageUrls
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSize32, MGMAlbumImageSize64, MGMAlbumImageSize128, MGMAlbumImageSize256, MGMAlbumImageSize512};
    return [self bestImagesWithPreferences:sizes];
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

@end
