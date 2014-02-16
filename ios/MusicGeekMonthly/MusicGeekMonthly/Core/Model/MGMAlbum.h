//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGMAlbumImageSize.h"
#import "MGMAlbumImageUri.h"
#import "MGMAlbumMetadata.h"
#import "MGMAlbumServiceType.h"

@interface MGMAlbum : NSManagedObject

@property (nonatomic, strong) NSString* albumMbid;
@property (nonatomic, strong) NSString* albumName;
@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSSet* imageUris;
@property (nonatomic, strong) NSSet* metadata;

@property (nonatomic) NSUInteger searchedServiceTypes;
@property (nonatomic) BOOL searchedImages;

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType;
- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType;

- (NSArray*) bestAlbumImageUrlsWithPreferredSize:(MGMAlbumImageSize)preferredSize;
- (NSArray*) bestTableImageUrls;
- (NSArray*) imageUrlsForImageSize:(MGMAlbumImageSize)size;
- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType;

@end

@interface MGMAlbum (CoreDataGeneratedAccessors)

- (void)addImageUrisObject:(MGMAlbumImageUri*)value;
- (void)addMetadataObject:(MGMAlbumMetadata*)value;

@end