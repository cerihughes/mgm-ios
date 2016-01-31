//
//  MGMLastFmPlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMLastFmPlayerService.h"

@implementation MGMLastFmPlayerService

#define ARTIST_URI @"lastfm://artist/%@/similarartists"

- (NSString*) serviceAvailabilityUrl
{
    return ARTIST_URI;
}

- (NSString*) urlForAlbum:(MGMAlbum*)album
{
    return [NSString stringWithFormat:ARTIST_URI, album.artistName];
}

@end
