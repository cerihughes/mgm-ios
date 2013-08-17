//
//  MGMAlbum+Relationships.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

#import "MGMAlbumImageUri.h"
#import "MGMAlbumMetadata.h"

@interface MGMAlbum (Relationships)

@property (nonatomic, strong) NSSet* imageUris;
@property (nonatomic, strong) NSSet* metadata;

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