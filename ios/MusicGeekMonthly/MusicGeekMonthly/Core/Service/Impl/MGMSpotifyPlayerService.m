//
//  MGMSpotifyPlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyPlayerService.h"

#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteJsonDataConverter.h"
#import "MGMSpotifyConstants.h"

@interface MGMSpotifyPlayerDataConverter : MGMRemoteJsonDataConverter

@end

@implementation MGMSpotifyPlayerDataConverter

#define TERRITORY @"GB"

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
    NSDictionary* albums = [json objectForKey:@"albums"];
    NSArray* items = [albums objectForKey:@"items"];
    NSArray* available = [self availableItems:items inTerritory:TERRITORY];
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
    NSString* value = [json objectForKey:@"id"];
    if (value)
    {
        MGMAlbumMetadataDto* metadata = [[MGMAlbumMetadataDto alloc] init];
        metadata.serviceType = MGMAlbumServiceTypeSpotify;
        metadata.value = value;
        return metadata;
    }
    return nil;
}

- (NSArray*) availableItems:(NSArray*)items inTerritory:(NSString*)territory
{
    NSMutableArray* available = [NSMutableArray arrayWithCapacity:items.count];

    for (NSDictionary* itemJson in items)
    {
        NSArray* territories = [itemJson objectForKey:@"available_markets"];
        if ([territories containsObject:@"worldwide"] || [territories containsObject:territory])
        {
            [available addObject:itemJson];
        }
    }

    return available;
}

- (NSDictionary*) bestMatchForAlbum:(MGMAlbum*)album inAlbums:(NSArray*)albumsJson
{
    NSLog(@"Found %lu matches in Spotify.", (unsigned long)albumsJson.count);
    for (NSDictionary* albumJson in albumsJson)
    {
        NSString* albumName = [albumJson objectForKey:@"name"];
        NSLog(@"Found %@", albumName);
        if ([albumName.lowercaseString isEqualToString:album.albumName.lowercaseString])
        {
            return albumJson;
        }
    }

    NSLog(@"No exact match - returning 1st album in results.");
    return albumsJson.count > 0 ? albumsJson[0] : nil;
}

@end

@interface MGMSpotifyPlayerService () <MGMRemoteHttpDataReaderDataSource>

@end

@implementation MGMSpotifyPlayerService

#define ALBUM_URI @"spotify:album:%@"
#define SEARCH_URI @"spotify:search:%@ %@"

- (MGMRemoteDataReader*) createRemoteDataReader
{
    MGMRemoteHttpDataReader *reader = [[MGMRemoteHttpDataReader alloc] init];
    reader.dataSource = self;
    return reader;
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    return [[MGMSpotifyPlayerDataConverter alloc] init];
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

- (NSString*) urlForPlaylist:(NSString*)spotifyPlaylistId
{
    if (spotifyPlaylistId)
    {
        return [NSString stringWithFormat:SPOTIFY_PLAYLIST_URI_PATTERN, SPOTIFY_USER_ANDREW_JONES, spotifyPlaylistId];
    }
    return nil;
}

#pragma mark - MGMRemoteHttpDataReaderDataSource

#define REST_SEARCH_URL @"http://api.spotify.com/v1/search?type=album&q=%@+%@"

- (NSString*) urlForKey:(id)key
{
    MGMAlbum* album = key;
    return [NSString stringWithFormat:REST_SEARCH_URL, album.artistName, album.albumName];
}

@end
