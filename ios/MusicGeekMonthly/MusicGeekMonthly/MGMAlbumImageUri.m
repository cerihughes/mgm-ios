//
//  MGMAlbumImageUri.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumImageUri.h"
#import "MGMAlbum.h"

@interface MGMAlbumImageUri ()

@property (nonatomic, strong) NSNumber* sizeObject;

@end

@implementation MGMAlbumImageUri

@dynamic sizeObject;
@dynamic uri;
@dynamic album;

- (MGMAlbumImageSize) size
{
    return [self.sizeObject integerValue];
}

- (void) setSize:(MGMAlbumImageSize)size
{
    self.sizeObject = [NSNumber numberWithInteger:size];
}

@end
