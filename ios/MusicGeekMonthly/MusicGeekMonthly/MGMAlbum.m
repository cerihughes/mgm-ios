//
//  MGMAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

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

- (NSString*) fetchImageUrlForImageSize:(MGMAlbumImageSize)size
{
    __block NSString* result;
    [self.managedObjectContext performBlockAndWait:^
    {
        result = [self imageUrlForImageSize:size];
    }];
    return result;
}

- (NSString*) fetchMetadataForServiceType:(MGMAlbumServiceType)serviceType
{
    __block NSString* result;
    [self.managedObjectContext performBlockAndWait:^
    {
        result = [self metadataForServiceType:serviceType];
    }];
    return result;
}

- (NSString*) fetchBestAlbumImageUrl
{
    __block NSString* result;
    [self.managedObjectContext performBlockAndWait:^
    {
        result = [self bestAlbumImageUrl];
    }];
    return result;
}

- (NSString*) fetchBestTableImageUrl
{
    __block NSString* result;
    [self.managedObjectContext performBlockAndWait:^
    {
        result = [self bestTableImageUrl];
    }];
    return result;
}

@end
