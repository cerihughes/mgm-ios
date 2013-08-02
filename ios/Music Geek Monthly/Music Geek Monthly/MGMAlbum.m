//
//  MGMAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

@interface MGMAlbum ()

@property (strong) NSMutableArray* searchedServiceTypes;
@property (strong) NSMutableDictionary* metadata;
@property (strong) NSMutableDictionary* imageUris;

@end

@implementation MGMAlbum

- (id)init
{
    if (self = [super init])
    {
        self.searchedServiceTypes = [NSMutableArray array];
        self.metadata = [NSMutableDictionary dictionary];
        self.imageUris = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType
{
    return [self.searchedServiceTypes containsObject:[NSNumber numberWithInt:serviceType]];
}

- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType
{
    [self.searchedServiceTypes addObject:[NSNumber numberWithInt:serviceType]];
}

- (NSString*) imageUrlForImageSize:(MGMAlbumImageSize)size
{
    return [self.imageUris objectForKey:[NSNumber numberWithInt:size]];
}

- (void) setImageUrl:(NSString*)imageUrl forImageSize:(MGMAlbumImageSize)size
{
    [self.imageUris setObject:imageUrl forKey:[NSNumber numberWithInt:size]];
}

- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType
{
    return [self.metadata objectForKey:[NSNumber numberWithInt:serviceType]];
}

- (void) setMetadata:(NSString*)metadata forServiceType:(MGMAlbumServiceType)serviceType
{
    [self.metadata setObject:metadata forKey:[NSNumber numberWithInt:serviceType]];
}

@end
