//
//  MGMAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

@interface MGMAlbum ()

@property (strong) NSMutableArray* internalSearchedServiceTypes;
@property (strong) NSMutableDictionary* internalImageUris;
@property (strong) NSMutableDictionary* internalMetadata;

@end

@implementation MGMAlbum

@dynamic albumMbid;
@dynamic albumName;
@dynamic artistName;
@dynamic imageUris;
@dynamic listeners;
@dynamic metadata;
@dynamic rank;
@dynamic score;
@dynamic searchedServiceTypes;

@synthesize internalSearchedServiceTypes;
@synthesize internalImageUris;
@synthesize internalMetadata;

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    self.internalSearchedServiceTypes = [NSMutableArray array];
    self.internalImageUris = [NSMutableDictionary dictionary];
    self.internalMetadata = [NSMutableDictionary dictionary];
}

- (void) awakeFromFetch
{
    [super awakeFromFetch];
    self.internalSearchedServiceTypes = [NSKeyedUnarchiver unarchiveObjectWithData:self.searchedServiceTypes];
    self.internalImageUris = [NSKeyedUnarchiver unarchiveObjectWithData:self.imageUris];
    self.internalMetadata = [NSKeyedUnarchiver unarchiveObjectWithData:self.metadata];
}

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType
{
    return [self.internalSearchedServiceTypes containsObject:[NSNumber numberWithInt:serviceType]];
}

- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType
{
    [self.internalSearchedServiceTypes addObject:[NSNumber numberWithInt:serviceType]];
    self.searchedServiceTypes = [NSKeyedArchiver archivedDataWithRootObject:self.internalSearchedServiceTypes];
}

- (NSString*) imageUrlForImageSize:(MGMAlbumImageSize)size
{
    return [self.internalImageUris objectForKey:[NSNumber numberWithInt:size]];
}

- (void) setImageUrl:(NSString*)imageUrl forImageSize:(MGMAlbumImageSize)size
{
    [self.internalImageUris setObject:imageUrl forKey:[NSNumber numberWithInt:size]];
    self.imageUris = [NSKeyedArchiver archivedDataWithRootObject:self.internalImageUris];
}

- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType
{
    return [self.internalMetadata objectForKey:[NSNumber numberWithInt:serviceType]];
}

- (void) setMetadata:(NSString*)metadata forServiceType:(MGMAlbumServiceType)serviceType
{
    [self.internalMetadata setObject:metadata forKey:[NSNumber numberWithInt:serviceType]];
    self.metadata = [NSKeyedArchiver archivedDataWithRootObject:self.internalMetadata];
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
    NSString* uri;
    if (self.rank.intValue == 1 && (uri = [self imageUrlForImageSize:MGMAlbumImageSizeMega]) != nil)
    {
        return uri;
    }

    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSizeExtraLarge, MGMAlbumImageSizeMega, MGMAlbumImageSizeLarge, MGMAlbumImageSizeMedium, MGMAlbumImageSizeSmall};
    return [self bestImageWithPreferences:sizes];
}

- (NSString*) bestTableImageUrl
{
    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSizeSmall, MGMAlbumImageSizeMedium, MGMAlbumImageSizeLarge, MGMAlbumImageSizeExtraLarge, MGMAlbumImageSizeMega};
    return [self bestImageWithPreferences:sizes];
}

@end
