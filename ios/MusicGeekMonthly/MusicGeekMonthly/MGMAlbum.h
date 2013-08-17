//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGMAlbumImageSize.h"
#import "MGMAlbumServiceType.h"

@interface MGMAlbum : NSManagedObject

@property (nonatomic, strong) NSString* albumMbid;
@property (nonatomic, strong) NSString* albumName;
@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSNumber* score;

@property (nonatomic) NSUInteger searchedServiceTypes;

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType;
- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType;

- (NSString*) fetchImageUrlForImageSize:(MGMAlbumImageSize)size;
- (NSString*) fetchMetadataForServiceType:(MGMAlbumServiceType)serviceType;

- (NSString*) fetchBestAlbumImageUrl;
- (NSString*) fetchBestTableImageUrl;

@end
