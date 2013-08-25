//
//  MGMAlbumServiceType.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

typedef enum
{
    MGMAlbumServiceTypeNone =      0x00,
    MGMAlbumServiceTypeLastFm =    0x01,
    MGMAlbumServiceTypeSpotify =   0x02,
    MGMAlbumServiceTypeWikipedia = 0x04,
    MGMAlbumServiceTypeYouTube =   0x08,
    MGMAlbumServiceTypeItunes =    0x10
}
MGMAlbumServiceType;
