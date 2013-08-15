//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MGMAlbumImageUri.h"
#import "MGMAlbumMetadata.h"

@interface MGMAlbum : NSManagedObject

@property (nonatomic, strong) NSString* albumMbid;
@property (nonatomic, strong) NSString* albumName;
@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSSet* imageUris;
@property (nonatomic, strong) NSSet* metadata;

@property (nonatomic) NSUInteger searchedServiceTypes;

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType;
- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType;

- (NSString*) imageUrlForImageSize:(MGMAlbumImageSize)size;
- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType;

- (NSString*) bestAlbumImageUrl;
- (NSString*) bestTableImageUrl;

@end

@interface MGMAlbum (CoreDataGeneratedAccessors)

- (void)addImageUrisObject:(MGMAlbumImageUri*)value;
- (void)removeImageUrisObject:(MGMAlbumImageUri*)value;

- (void)addMetadataObject:(MGMAlbumMetadata*)value;
- (void)removeMetadataObject:(MGMAlbumMetadata*)value;

@end
