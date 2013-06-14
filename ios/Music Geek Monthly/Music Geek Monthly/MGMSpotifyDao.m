//
//  MGMSpotifyDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyDao.h"

#define ALBUM_SEARCH_URL @"http://ws.spotify.com/search/1/album?q=%@"

@interface MGMSpotifyDao()

@property (strong) NSDictionary* acceptJson;

@end

@implementation MGMSpotifyDao

- (id) init
{
    if (self = [super init])
    {
        self.acceptJson = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
    }
    return self;
}

- (void) updateAlbumInfo:(MGMGroupAlbum *)album
{
    NSString* searchString = [NSString stringWithFormat:@"%@ %@", album.artistName, album.albumName];
    NSString* urlString = [NSString stringWithFormat:ALBUM_SEARCH_URL, searchString];
    NSError* error = nil;
    NSData* jsonData = [self getContentsOfUrl:urlString withHttpHeaders:self.acceptJson];
    if (error == nil)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            [self updateAlbumInfo:album withJson:json];
        }
    }
}

- (void) updateAlbumInfo:(MGMGroupAlbum*)album withJson:(NSDictionary*)json
{
    album.searchedSpotifyData = YES;
    NSArray* albums = [json objectForKey:@"albums"];
    if (albums.count == 1)
    {
        [self updateAlbumInfo:album withAlbumJson:[albums objectAtIndex:0]];
    }
    else if (albums.count > 1)
    {
        // TODO: this
    }
}

- (void) updateAlbumInfo:(MGMGroupAlbum*)album withAlbumJson:(NSDictionary*)json
{
    album.spotifyUri = [json objectForKey:@"href"];
}

@end
