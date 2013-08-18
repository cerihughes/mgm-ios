//
//  MGMAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

#import "NSManagedObjectContext+Debug.h"
#import "MGMAlbum+Relationships.h"

@interface MGMAlbum ()

@property (nonatomic, strong) NSNumber* searchedServiceTypesObject;

@end

@implementation MGMAlbum

@dynamic albumMbid;
@dynamic albumName;
@dynamic artistName;
@dynamic score;
@dynamic searchedServiceTypesObject;

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

- (void) persistImageUrisObject:(MGMAlbumImageUri*)value
{
    [self.managedObjectContext debugPerformBlockAndWait:^
    {
        [self addImageUrisObject:value];
    }];
}

- (void) persistMetadataObject:(MGMAlbumMetadata*)value
{
    [self.managedObjectContext debugPerformBlockAndWait:^
    {
        [self addMetadataObject:value];
    }];
}

- (NSString*) fetchBestImageWithPreferences:(MGMAlbumImageSize[5])sizes
{
    for (NSUInteger i = 0; i < 5; i++)
    {
        NSString* uri = [self fetchImageUrlForImageSize:sizes[i]];
        if (uri)
        {
            return uri;
        }
    }
    return nil;
}

- (NSString*) fetchBestAlbumImageUrl
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSizeExtraLarge, MGMAlbumImageSizeMega, MGMAlbumImageSizeLarge, MGMAlbumImageSizeMedium, MGMAlbumImageSizeSmall};
    return [self fetchBestImageWithPreferences:sizes];
}

- (NSString*) fetchBestTableImageUrl
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSizeSmall, MGMAlbumImageSizeMedium, MGMAlbumImageSizeLarge, MGMAlbumImageSizeExtraLarge, MGMAlbumImageSizeMega};
    return [self fetchBestImageWithPreferences:sizes];
}

- (NSString*) fetchImageUrlForImageSize:(MGMAlbumImageSize)size
{
    __block NSSet* uriSet;
    [self.managedObjectContext debugPerformBlockAndWait:^
    {
        uriSet = self.imageUris;
    }];
    
    for (MGMAlbumImageUri* uri in uriSet)
    {
        if (uri.size == size)
        {
            return uri.uri;
        }
    }
    return nil;
}

- (NSString*) fetchMetadataForServiceType:(MGMAlbumServiceType)serviceType
{
    __block NSSet* metadataSet;
    [self.managedObjectContext debugPerformBlockAndWait:^
    {
        metadataSet = self.metadata;
    }];

    for (MGMAlbumMetadata* metadata in metadataSet)
    {
        if (metadata.serviceType == serviceType)
        {
            return metadata.value;
        }
    }
    return nil;
}

@end
