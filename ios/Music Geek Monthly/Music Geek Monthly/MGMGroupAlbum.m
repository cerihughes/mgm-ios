//
//  MGMGroupAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMGroupAlbum.h"

@implementation MGMGroupAlbum

- (NSString*) bestAlbumImageUrl
{
    NSString* uri;
    if (self.rank == 1 && (uri = [self imageUrlForImageSize:MGMAlbumImageSizeMega]) != nil)
    {
        return uri;
    }

    return [super bestAlbumImageUrl];
}

@end
