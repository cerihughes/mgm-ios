//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

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

typedef enum
{
    MGMAlbumServiceTypeNone = 0,
    MGMAlbumServiceTypeLastFm = 1,
    MGMAlbumServiceTypeSpotify = 2,
    MGMAlbumServiceTypeWikipedia = 3,
    MGMAlbumServiceTypeYouTube = 4
}
MGMAlbumServiceType;

@interface MGMAlbum : NSManagedObject

@property (nonatomic, retain) NSString* albumMbid;
@property (nonatomic, retain) NSString* albumName;
@property (nonatomic, retain) NSString* artistName;
@property (nonatomic, retain) NSData* imageUris;
@property (nonatomic, retain) NSNumber* listeners;
@property (nonatomic, retain) NSData* metadata;
@property (nonatomic, retain) NSNumber* rank;
@property (nonatomic, retain) NSNumber* score;
@property (nonatomic, retain) NSData* searchedServiceTypes;

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType;
- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType;

- (NSString*) imageUrlForImageSize:(MGMAlbumImageSize)size;
- (void) setImageUrl:(NSString*)imageUrl forImageSize:(MGMAlbumImageSize)size;

- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType;
- (void) setMetadata:(NSString*)metadata forServiceType:(MGMAlbumServiceType)serviceType;

- (NSString*) bestAlbumImageUrl;
- (NSString*) bestTableImageUrl;

@end
