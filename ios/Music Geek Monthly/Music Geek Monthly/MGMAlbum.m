//
//  MGMAlbum.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbum.h"

#define URI_PATTERN_SPOTIFY @"spotify:album:%@"
#define URI_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/%@"
#define URI_PATTERN_YOUTUBE @"http://www.youtube.com/watch?v=%@"

@implementation MGMAlbum

- (NSString*) uriForMetadataKey:(NSString*)metadataKey pattern:(NSString*)pattern
{
    NSString* data = [self.metadata objectForKey:metadataKey];
    if (data)
    {
        return [NSString stringWithFormat:pattern, data];
    }
    return nil;
}

- (NSString*) lastFmUri
{
    return nil;
}

- (NSString*) spotifyUri
{
    return [self uriForMetadataKey:METADATA_KEY_SPOTIFY pattern:URI_PATTERN_SPOTIFY];
}

- (NSString*) wikipediaUri
{
    return [self uriForMetadataKey:METADATA_KEY_WIKIPEDIA pattern:URI_PATTERN_WIKIPEDIA];
}

- (NSString*) youTubeUri
{
    return [self uriForMetadataKey:METADATA_KEY_YOUTUBE pattern:URI_PATTERN_YOUTUBE];
}

@end
