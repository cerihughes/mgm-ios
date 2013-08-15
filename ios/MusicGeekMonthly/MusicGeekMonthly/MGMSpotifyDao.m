//
//  MGMSpotifyDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyDao.h"

@interface MGMSpotifyDao ()

@property (strong) NSDictionary* acceptJson;

@end

@implementation MGMSpotifyDao

#define ALBUM_SEARCH_URL @"http://ws.spotify.com/search/1/album?q=%@"
#define TERRITORY @"GB"

- (id) init
{
    if (self = [super init])
    {
        self.acceptJson = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
    }
    return self;
}

- (void) updateAlbumInfo:(MGMAlbum *)album error:(NSError**)error
{
    NSString* searchString = [NSString stringWithFormat:@"%@ %@", album.artistName, album.albumName];
    NSString* urlString = [NSString stringWithFormat:ALBUM_SEARCH_URL, searchString];
    NSData* jsonData = [self contentsOfUrl:urlString withHttpHeaders:self.acceptJson];
    if (jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
        if (error  && *error != nil)
        {
            return;
        }
        [self updateAlbumInfo:album withJson:json error:error];
    }
}

- (void) updateAlbumInfo:(MGMAlbum*)album withJson:(NSDictionary*)json error:(NSError**)error
{
    NSArray* albums = [json objectForKey:@"albums"];
    NSArray* available = [self availableAlbums:albums inTerritory:TERRITORY];
    NSDictionary* match = nil;
    if (available.count == 1)
    {
        match = [available objectAtIndex:0];
    }
    else if (available.count > 1)
    {
        match = [self bestMatchForAlbum:album inAlbums:available];
    }
    [self updateAlbumInfo:album withAlbumJson:match error:error];
}

- (void) updateAlbumInfo:(MGMAlbum*)album withAlbumJson:(NSDictionary*)json error:(NSError**)error
{
    NSString* href = [json objectForKey:@"href"];
    NSArray* splits = [href componentsSeparatedByString:@":"];
    if (splits.count == 3)
    {
        NSString* value = [splits objectAtIndex:2];

        MGMAlbumMetadata* metadata = [self.coreDataDao fetchAlbumMetadataForAlbum:album serviceType:MGMAlbumServiceTypeSpotify error:error];
        if (error && *error != nil)
        {
            return;
        }

        if (metadata == nil)
        {
            metadata = [self.coreDataDao createNewAlbumMetadata:error];
            if (error && *error != nil)
            {
                return;
            }

            metadata.serviceType = MGMAlbumServiceTypeSpotify;
            metadata.value = value;
            [album addMetadataObject:metadata];
            [self.coreDataDao persistChanges:error];

            if (error && *error != nil)
            {
                return;
            }
        }
    }
}

- (NSArray*) availableAlbums:(NSArray*)albums inTerritory:(NSString*)territory
{
    NSMutableArray* available = [NSMutableArray arrayWithCapacity:albums.count];

    for (NSDictionary* albumJson in albums)
    {
        NSString* territories = [[albumJson objectForKey:@"availability"] objectForKey:@"territories"];
        if ([territories isEqualToString:@"worldwide"] || [territories rangeOfString:territory].location != NSNotFound)
        {
            [available addObject:albumJson];
        }
    }

    return available;
}

- (NSDictionary*) bestMatchForAlbum:(MGMAlbum*)album inAlbums:(NSArray*)albumsJson
{
    NSLog(@"Found %d matches in Spotify.", albumsJson.count);
    float mostPopularValue = 0;
    NSDictionary* mostPopularAlbum = nil;
    for (NSDictionary* albumJson in albumsJson)
    {
        NSString* albumName = [albumJson objectForKey:@"name"];
        NSArray* artists = [albumJson objectForKey:@"artists"];
        NSString* popularityString = [albumJson objectForKey:@"popularity"];
        float popularity = [popularityString floatValue];
        if (popularity > mostPopularValue)
        {
            mostPopularValue = popularity;
            mostPopularAlbum = albumJson;
        }

        for (NSDictionary* artist in artists)
        {
            NSString* artistName = [artist objectForKey:@"name"];
            NSLog(@"Found %@ - %@", albumName, artistName);
            if ([self album:album isExactMatchForArtistName:artistName albumName:albumName])
            {
                return albumJson;
            }
        }
    }
    // What the hell... let's return the most popular...
    NSLog(@"No exact match - returning most popular album in results.");
    return mostPopularAlbum;
}

- (BOOL) album:(MGMAlbum*)album isExactMatchForArtistName:(NSString*)artistName albumName:(NSString*)albumName
{
    NSLog(@"Found %@ - %@", albumName, artistName);
    if ([artistName.lowercaseString isEqualToString:album.artistName.lowercaseString] && [albumName.lowercaseString isEqualToString:album.albumName.lowercaseString])
    {
        return YES;
    }
    return NO;
}

@end
