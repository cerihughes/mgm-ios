//
//  MGMAlbumMetadata.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumMetadata.h"
#import "MGMAlbum.h"

@interface MGMAlbumMetadata ()

@property (nonatomic, strong) NSNumber* serviceTypeObject;

@end

@implementation MGMAlbumMetadata

@dynamic serviceTypeObject;
@dynamic value;
@dynamic album;

- (MGMAlbumServiceType) serviceType
{
    return (MGMAlbumServiceType)[self.serviceTypeObject integerValue];
}

- (void) setServiceType:(MGMAlbumServiceType)serviceType
{
    self.serviceTypeObject = [NSNumber numberWithInteger:serviceType];
}

@end
