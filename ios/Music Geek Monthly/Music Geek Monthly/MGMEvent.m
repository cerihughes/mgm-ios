//
//  MGMEvent.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEvent.h"

@implementation MGMEvent

- (NSString*) spotifyPlaylistUrl
{
    if (self.spotifyPlaylistId)
    {
        return [NSString stringWithFormat:SPOTIFY_PLAYLIST_URI_PATTERN, SPOTIFY_USER_ANDREW_JONES, self.spotifyPlaylistId];
    }
    return nil;
}

- (NSString*) spotifyHttpUrl
{
    if (self.spotifyPlaylistId)
    {
        return [NSString stringWithFormat:HTTP_PLAYLIST_URI_PATTERN, SPOTIFY_USER_ANDREW_JONES, self.spotifyPlaylistId];
    }
    return nil;
}

@end
