//
//  MGMAlbumImageSize.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumImageSize.h"

MGMAlbumImageSize preferredImageSize(CGSize viewSize, CGFloat scale)
{
    CGFloat size = MIN(viewSize.width, viewSize.height) * scale;
    if (size > 512)
    {
        return MGMAlbumImageSize512;
    }
    if (size > 256)
    {
        return MGMAlbumImageSize256;
    }
    else if (size > 128)
    {
        return MGMAlbumImageSize128;
    }
    else if (size > 64)
    {
        return MGMAlbumImageSize64;
    }
    else if (size > 32)
    {
        return MGMAlbumImageSize32;
    }
    return MGMAlbumImageSizeNone;
}
