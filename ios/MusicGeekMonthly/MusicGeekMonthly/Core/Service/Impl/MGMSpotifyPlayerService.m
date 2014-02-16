//
//  MGMSpotifyPlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyPlayerService.h"

@interface MGMSpotifyPlayerService ()

@property (strong) NSDictionary* acceptJson;

@end

@implementation MGMSpotifyPlayerService

#define REST_SEARCH_URL @"http://ws.spotify.com/search/1/album?q=%@+%@"
#define TERRITORY @"GB"

#define ALBUM_URI @"spotify:album:%@"
#define SEARCH_URI @"spotify:search:%@ %@"

static NSDictionary* acceptJson;

- (id) init
{
    if (self = [super init])
    {
        self.acceptJson = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
    }
    return self;
}

- (MGMAlbumServiceType) serviceType
{
    return MGMAlbumServiceTypeSpotify;
}

- (NSString*) serviceAvailabilityUrl
{
    return ALBUM_URI;
}

- (NSString*) urlForAlbum:(MGMAlbum*)album
{
    NSString* metadata = [album metadataForServiceType:MGMAlbumServiceTypeSpotify];
    if (metadata)
    {
        return [NSString stringWithFormat:ALBUM_URI, metadata];
    }
    else
    {
        return [NSString stringWithFormat:SEARCH_URI, album.artistName, album.albumName];
    }
}

#pragma mark -
#pragma mark MGMRemoteDataSource

- (NSString*) urlForKey:(id)key
{
    MGMAlbum* album = key;
    return [NSString stringWithFormat:REST_SEARCH_URL, album.artistName, album.albumName];
}

- (NSDictionary*) httpHeaders
{
    return self.acceptJson;
}

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
{
    MGMAlbum* album = key;
    MGMAlbumMetadataDto* metadata = [self metadataForAlbum:album withJson:json];
    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = metadata;
    return remoteData;
}

- (MGMAlbumMetadataDto*) metadataForAlbum:(MGMAlbum*)album withJson:(NSDictionary*)json
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
    return [self metadataForAlbum:album withAlbumJson:match];
}

- (MGMAlbumMetadataDto*) metadataForAlbum:(MGMAlbum*)album withAlbumJson:(NSDictionary*)json
{
    NSString* href = [json objectForKey:@"href"];
    NSArray* splits = [href componentsSeparatedByString:@":"];
    if (splits.count == 3)
    {
        NSString* value = [splits objectAtIndex:2];

        MGMAlbumMetadataDto* metadata = [[MGMAlbumMetadataDto alloc] init];
        metadata.serviceType = MGMAlbumServiceTypeSpotify;
        metadata.value = value;
        return metadata;
    }
    return nil;
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
    NSLog(@"Found %lu matches in Spotify.", (unsigned long)albumsJson.count);
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
