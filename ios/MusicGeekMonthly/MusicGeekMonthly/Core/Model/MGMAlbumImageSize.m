//
//  MGMAlbumImageSize.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumImageSize.h"

MGMAlbumImageSize preferredImageSize(CGSize viewSize)
{
    CGFloat width = viewSize.width;
    if (width > 512)
    {
        return MGMAlbumImageSize512;
    }
    if (width > 256)
    {
        return MGMAlbumImageSize256;
    }
    else if (width > 128)
    {
        return MGMAlbumImageSize128;
    }
    else if (width > 64)
    {
        return MGMAlbumImageSize64;
    }
    else if (width > 32)
    {
        return MGMAlbumImageSize32;
    }
    return MGMAlbumImageSizeNone;
}
