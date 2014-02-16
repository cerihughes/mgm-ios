//
//  MGMEvent.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEvent.h"

#define SPOTIFY_PLAYLIST_URI_PATTERN @"spotify:user:%@:playlist:%@"
#define HTTP_PLAYLIST_URI_PATTERN @"http://open.spotify.com/user/%@/playlist/%@"
#define SPOTIFY_USER_ANDREW_JONES @"fuzzylogic1981"

@implementation MGMEvent

@dynamic eventDate;
@dynamic eventNumber;
@dynamic spotifyPlaylistId;
@dynamic classicAlbum;
@dynamic newlyReleasedAlbum;

static NSDateFormatter* groupHeaderFormatter;
static NSDateFormatter* groupItemFormatter;

+ (void)initialize
{
    // yyyy
    groupHeaderFormatter = [[NSDateFormatter alloc] init];
    groupHeaderFormatter.dateFormat = @"yyyy";

    // MMM yyyy
    groupItemFormatter = [[NSDateFormatter alloc] init];
    groupItemFormatter.dateFormat = @"MMM yyyy";
}

- (NSString*) groupHeader
{
    [self willAccessValueForKey:@"groupHeader"];
    NSString* header = [groupHeaderFormatter stringFromDate:self.eventDate];
    [self didAccessValueForKey:@"groupHeader"];
    return header;
}

- (NSString*) groupValue
{
    [self willAccessValueForKey:@"groupValue"];
    NSString* value = [groupItemFormatter stringFromDate:self.eventDate];
    [self didAccessValueForKey:@"groupValue"];
    return value;
}

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
