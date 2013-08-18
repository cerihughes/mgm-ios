//
//  MGMAlbum+Relationships.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 17/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

@interface MGMAlbum (Relationships)

@property (nonatomic, strong) NSSet* imageUris;
@property (nonatomic, strong) NSSet* metadata;

@end

@interface MGMAlbum (CoreDataGeneratedAccessors)

- (void)addImageUrisObject:(MGMAlbumImageUri*)value;
- (void)addMetadataObject:(MGMAlbumMetadata*)value;

@end