//
//  MGMAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

@implementation MGMAlbum

- (NSString*) spotifyAlbumUri
{
    if (self.spotifyAlbumId)
    {
        return [NSString stringWithFormat:SPOTIFY_ALBUM_URI_PATTERN, self.spotifyAlbumId];
    }
    return nil;
}

@end
