//
//  MGMFetchSpotifyAlbumMetadataOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchSpotifyAlbumMetadataOperation.h"

#import "MGMAlbumMetadataDto.h"

#define REFRESH_IDENTIFIER_SPOTIFY_METADATA @"REFRESH_IDENTIFIER_SPOTIFY_METADATA_%@_%@"
#define ALBUM_SEARCH_URL @"http://ws.spotify.com/search/1/album?q=%@+%@"
#define TERRITORY @"GB"

@implementation MGMFetchSpotifyAlbumMetadataOperation

static NSDictionary* acceptJson;

+ (void) initialize
{
    acceptJson = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
}

- (NSString*) refreshIdentifierForData:(id)data
{
    MGMAlbum* album = data;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_SPOTIFY_METADATA, album.artistName, album.albumName];
}

- (NSDictionary*) httpHeaders
{
    return acceptJson;
}

- (NSString*) urlForData:(id)data
{
    MGMAlbum* album = data;
    return [NSString stringWithFormat:ALBUM_SEARCH_URL, album.artistName, album.albumName];
}

- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion
{
    MGMAlbum* album = data;
    MGMAlbumMetadataDto* metadataDto = [self updateAlbumInfo:album withJson:json];
    if (metadataDto)
    {
        NSArray* metadataDtos = [NSArray arrayWithObject:metadataDto];
        completion(metadataDtos, nil);
    }
    else
    {
        completion(nil, nil);
    }
}

- (MGMAlbumMetadataDto*) updateAlbumInfo:(MGMAlbum*)album withJson:(NSDictionary*)json
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

- (void) coreDataPersistConvertedData:(id)convertedUrlData withData:(id)data completion:(VOID_COMPLETION)completion
{
    MGMAlbum* album = data;
    [self.coreDataDao addMetadata:convertedUrlData toAlbumWithMbid:album.albumMbid updateServiceType:MGMAlbumServiceTypeSpotify completion:completion];
}

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    MGMAlbum* album = data;
    [self.coreDataDao fetchAlbumWithMbid:album.albumMbid completion:completion];
}

@end
