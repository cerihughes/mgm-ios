//
//  MGMAlbumImageSize.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MGMAlbumImageSize)
{
    MGMAlbumImageSizeNone = 0,
    MGMAlbumImageSize32   = 32,
    MGMAlbumImageSize64   = 64,
    MGMAlbumImageSize128  = 128,
    MGMAlbumImageSize256  = 256,
    MGMAlbumImageSize512  = 512
};

MGMAlbumImageSize preferredImageSize(CGSize viewSize, CGFloat scale);
