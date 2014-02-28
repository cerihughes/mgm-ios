//
//  MGMAlbum.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMImagedEntity.h"

#import "MGMAlbumMetadata.h"
#import "MGMAlbumServiceType.h"

@interface MGMAlbum : MGMImagedEntity

@property (nonatomic, strong) NSString* albumMbid;
@property (nonatomic, strong) NSString* albumName;
@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSSet* metadata;

@property (nonatomic) NSUInteger searchedServiceTypes;
@property (nonatomic) BOOL searchedImages;

- (BOOL) searchedServiceType:(MGMAlbumServiceType)serviceType;
- (void) setServiceTypeSearched:(MGMAlbumServiceType)serviceType;

- (NSString*) metadataForServiceType:(MGMAlbumServiceType)serviceType;

@end
