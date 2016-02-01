//
//  MGMItunesPlayerService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/04/15.
//  Copyright (c) 2015 Ceri Hughes. All rights reserved.
//

#import "MGMItunesPlayerService.h"

#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteJsonDataConverter.h"
#import "MGMSpotifyConstants.h"

@interface MGMItunesPlayerService () <MGMRemoteHttpDataReaderDataSource, MGMRemoteJsonDataConverterDelegate>

@end

@implementation MGMItunesPlayerService

#define ALBUM_URI @"https://itunes.apple.com/gb/album/%@?uo=4"

- (MGMRemoteDataReader*) createRemoteDataReader
{
    MGMRemoteHttpDataReader *reader = [[MGMRemoteHttpDataReader alloc] init];
    reader.dataSource = self;
    return reader;
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    MGMRemoteJsonDataConverter *converter = [[MGMRemoteJsonDataConverter alloc] init];
    converter.delegate = self;
    return converter;
}

- (NSString*) serviceAvailabilityUrl
{
    return ALBUM_URI;
}

- (NSString*) urlForAlbum:(MGMAlbum*)album
{
    return [album metadataForServiceType:MGMAlbumServiceTypeItunes];
}

#pragma mark - MGMRemoteHttpDataReaderDataSource

#define REST_SEARCH_URL @"https://itunes.apple.com/search?entity=album&country=GB&term=%@+%@"

- (NSString*) urlForKey:(id)key
{
    MGMAlbum* album = key;
    return [NSString stringWithFormat:REST_SEARCH_URL, album.artistName, album.albumName];
}

#pragma mark - MGMRemoteJsonDataConverterDelegate

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
    NSArray* results = json[@"results"];
    NSDictionary* match = nil;
    if (results.count == 1) {
        match = [results objectAtIndex:0];
    } else if (results.count > 1) {
        match = [self bestMatchForAlbum:album inAlbums:results];
    }
    return [self metadataForAlbum:album withAlbumJson:match];
}

- (MGMAlbumMetadataDto*) metadataForAlbum:(MGMAlbum*)album withAlbumJson:(NSDictionary*)json
{
    NSString* collectionViewUrl = json[@"collectionViewUrl"];
    if (collectionViewUrl) {
        MGMAlbumMetadataDto* metadata = [[MGMAlbumMetadataDto alloc] init];
        metadata.serviceType = MGMAlbumServiceTypeItunes;
        metadata.value = collectionViewUrl;
        return metadata;
    }
    return nil;
}

- (NSDictionary*) bestMatchForAlbum:(MGMAlbum*)album inAlbums:(NSArray*)albumsJson
{
    NSLog(@"Found %lu matches in iTunes.", (unsigned long)albumsJson.count);
    for (NSDictionary* albumJson in albumsJson)
    {
        NSString* albumName = [albumJson objectForKey:@"collectionName"];
        NSString* artistName = [albumJson objectForKey:@"artistName"];
        if ([self album:album isExactMatchForArtistName:artistName albumName:albumName])
        {
            return albumJson;
        }
    }
    // What the hell... let's return the 1st...
    NSLog(@"No exact match - returning 1st album in results.");
    return albumsJson[0];
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
