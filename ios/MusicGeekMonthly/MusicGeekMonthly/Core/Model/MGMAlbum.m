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
@property (nonatomic, strong) NSNumber* searchedImagesObject;

@end

@implementation MGMAlbum

@dynamic albumMbid;
@dynamic albumName;
@dynamic artistName;
@dynamic score;
@dynamic searchedServiceTypesObject;
@dynamic searchedImagesObject;
@dynamic metadata;

- (NSUInteger) searchedServiceTypes
{
    return [self.searchedServiceTypesObject integerValue];
}

- (void) setSearchedServiceTypes:(NSUInteger)searchedServiceTypes
{
    self.searchedServiceTypesObject = [NSNumber numberWithInteger:searchedServiceTypes];
}

- (BOOL) searchedImages
{
    return [self.searchedImagesObject boolValue];
}

- (void) setSearchedImages:(BOOL)searchedImages
{
    self.searchedImagesObject = [NSNumber numberWithBool:searchedImages];
}

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType
{
    return (self.searchedServiceTypes & serviceType) == serviceType;
}

- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType
{
    self.searchedServiceTypes |= serviceType;
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
