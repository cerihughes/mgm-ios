//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MGMAlbumImageSizeSmall,
    MGMAlbumImageSizeMedium,
    MGMAlbumImageSizeLarge,
    MGMAlbumImageSizeExtraLarge,
    MGMAlbumImageSizeMega
}
MGMAlbumImageSize;

typedef enum
{
    MGMAlbumServiceTypeLastFm,
    MGMAlbumServiceTypeSpotify,
    MGMAlbumServiceTypeWikipedia,
    MGMAlbumServiceTypeYouTube
}
MGMAlbumServiceType;

@interface MGMAlbum : NSObject

@property (strong) NSString* artistName;
@property (strong) NSString* albumName;
@property (strong) NSString* albumMbid;
@property (strong) NSNumber* score;

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType;
- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType;

- (NSString*) imageUrlForImageSize:(MGMAlbumImageSize)size;
- (void) setImageUrl:(NSString*)imageUrl forImageSize:(MGMAlbumImageSize)size;

- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType;
- (void) setMetadata:(NSString*)metadata forServiceType:(MGMAlbumServiceType)serviceType;

- (NSString*) bestAlbumImageUrl;
- (NSString*) bestTableImageUrl;

@end
