//
//  MGMSpotifyDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyDao.h"
#import "MGMSpotifyPlaylist.h"

@interface MGMSpotifyDao ()

@property (strong) NSDictionary* acceptJson;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMSpotifyDao

#define ALBUM_SEARCH_URL @"http://ws.spotify.com/search/1/album?q=%@"
#define TERRITORY @"GB"

- (id) init
{
    if (self = [super init])
    {
        self.acceptJson = [NSDictionary dictionaryWithObject:@"application/json" forKey:@"Accept"];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    }
    return self;
}

- (MGMSpotifyPlaylist*) playlistWithEventNumber:(NSUInteger)eventNumber eventDate:(NSString*)eventDate spotifyUrl:(NSString*)spotifyUrl httpUrl:(NSString*)httpUrl
{
    NSDate* date = [self.dateFormatter dateFromString:eventDate];
    return [MGMSpotifyPlaylist playlistWithEventNumber:eventNumber eventDate:date spotifyUrl:spotifyUrl httpUrl:httpUrl];
}

- (NSArray*) eventPlaylists
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:5];

    [array addObject:[self playlistWithEventNumber:29 eventDate:@"29/05/2013" spotifyUrl:@"spotify:user:fuzzylogic1981:playlist:7ehW6P8sKvkPkM5kJv3VVl" httpUrl:@"http://open.spotify.com/user/fuzzylogic1981/playlist/7ehW6P8sKvkPkM5kJv3VVl"]];
    [array addObject:[self playlistWithEventNumber:28 eventDate:@"25/04/2013" spotifyUrl:@"spotify:user:fuzzylogic1981:playlist:56gYGCP1ByZZ0uvk8eZgv7" httpUrl:@"http://open.spotify.com/user/fuzzylogic1981/playlist/56gYGCP1ByZZ0uvk8eZgv7"]];
    [array addObject:[self playlistWithEventNumber:27 eventDate:@"25/03/2013" spotifyUrl:@"spotify:user:fuzzylogic1981:playlist:00kmjX7GFQrBtuGydkhebH" httpUrl:@"http://open.spotify.com/user/fuzzylogic1981/playlist/00kmjX7GFQrBtuGydkhebH"]];
    [array addObject:[self playlistWithEventNumber:26 eventDate:@"28/02/2013" spotifyUrl:@"spotify:user:fuzzylogic1981:playlist:2uRJfoDsShTYIEkrUadhZ1" httpUrl:@"http://open.spotify.com/user/fuzzylogic1981/playlist/2uRJfoDsShTYIEkrUadhZ1"]];
    [array addObject:[self playlistWithEventNumber:25 eventDate:@"24/01/2013" spotifyUrl:@"spotify:user:fuzzylogic1981:playlist:5a7AaNPsZAUGy29GRJiGnN" httpUrl:@"http://open.spotify.com/user/fuzzylogic1981/playlist/5a7AaNPsZAUGy29GRJiGnN"]];

    return [array copy];
}

- (void) updateAlbumInfo:(MGMGroupAlbum *)album
{
    NSString* searchString = [NSString stringWithFormat:@"%@ %@", album.artistName, album.albumName];
    NSString* urlString = [NSString stringWithFormat:ALBUM_SEARCH_URL, searchString];
    NSError* error = nil;
    NSData* jsonData = [self contentsOfUrl:urlString withHttpHeaders:self.acceptJson];
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
    [self updateAlbumInfo:album withAlbumJson:match];
}

- (void) updateAlbumInfo:(MGMGroupAlbum*)album withAlbumJson:(NSDictionary*)json
{
    album.spotifyUri = [json objectForKey:@"href"];
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

- (NSDictionary*) bestMatchForAlbum:(MGMGroupAlbum*)album inAlbums:(NSArray*)albumsJson
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

- (BOOL) album:(MGMGroupAlbum*)album isExactMatchForArtistName:(NSString*)artistName albumName:(NSString*)albumName
{
    NSLog(@"Found %@ - %@", albumName, artistName);
    if ([artistName.lowercaseString isEqualToString:album.artistName.lowercaseString] && [albumName.lowercaseString isEqualToString:album.albumName.lowercaseString])
    {
        return YES;
    }
    return NO;
}

@end
