//
//  MGMPlaylistDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 22/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPlaylistDaoOperation.h"

#import "MGMErrorCodes.h"
#import "MGMPlaylistDto.h"
#import "MGMPlaylistItemDto.h"

@implementation MGMPlaylistDaoOperation

#define REFRESH_IDENTIFIER_PLAYLIST @"REFRESH_IDENTIFIER_PLAYLIST_ID_%@"

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    MGMLocalDataSource* localDataSource = [[MGMPlaylistLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
    MGMRemoteDataSource* remoteDataSource = [[MGMPlaylistRemoteDataSource alloc] init];
    return [super initWithCoreDataAccess:coreDataAccess localDataSource:localDataSource remoteDataSource:remoteDataSource daysBetweenRemoteFetch:7];
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    NSString* data = key;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_PLAYLIST, data];
}

@end

@interface MGMPlaylistLocalDataSource ()

@property (readonly) NSMutableDictionary* playlists;

@end

@implementation MGMPlaylistLocalDataSource

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super initWithCoreDataAccess:coreDataAccess])
    {
        _playlists = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (MGMLocalData*) fetchLocalData:(id)key
{
    MGMLocalData* localData = [[MGMLocalData alloc] init];
    localData.data = [self.playlists objectForKey:key];
    return localData;
}

- (BOOL) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key error:(NSError**)error
{
    [self.playlists setObject:remoteData.data forKey:key];
    return YES;
}

@end

@implementation MGMPlaylistRemoteDataSource

#define SPOTIFY_PLAYLIST_URI_PATTERN @"spotify:user:%@:playlist:%@"
#define SPOTIFY_USER_ANDREW_JONES @"fuzzylogic1981"
#define EMBEDDED_PLAYLIST_URL @"https://embed.spotify.com/?uri=%@"

- (NSString*) urlForKey:(id)key
{
    NSString* data = key;
    NSString* spotifyUrl = [NSString stringWithFormat:SPOTIFY_PLAYLIST_URI_PATTERN, SPOTIFY_USER_ANDREW_JONES, data];
    return [NSString stringWithFormat:EMBEDDED_PLAYLIST_URL, spotifyUrl];
}

- (MGMRemoteData*) convertRemoteData:(NSData *)remoteData key:(id)key
{
    NSString* string = [[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];

    // Remove erroneous meta tags...
    string = [string stringByReplacingOccurrencesOfString:@"<meta charset=\"UTF-8\">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</meta>" withString:@""];

    // Tidy up ampersands
    string = [string stringByReplacingOccurrencesOfString:@" & " withString:@" &amp; "];
    
    NSData* modifiedData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [super convertRemoteData:modifiedData key:key];
}

- (MGMRemoteData*) convertXmlData:(NSDictionary *)xml key:(id)key
{
    @try
    {
        NSDictionary* html = [xml objectForKey:@"html"];
        NSDictionary* body = [html objectForKey:@"body"];
        NSDictionary* div1 = [body objectForKey:@"div"][0];
        NSDictionary* div2 = [div1 objectForKey:@"div"];
        NSDictionary* div3 = [div2 objectForKey:@"div"][2];
        NSDictionary* ul = [div3 objectForKey:@"ul"];
        NSArray* liArray = [ul objectForKey:@"li"];

        MGMRemoteData* data = [[MGMRemoteData alloc] init];
        MGMPlaylistDto* playlist = [[MGMPlaylistDto alloc] init];
        playlist.spotifyPlaylistId = key;
        for (NSDictionary* li in liArray)
        {
            [playlist.playlistItems addObject:[self playlistItemForLi:li]];
        }
        data.data = playlist;
        return data;
    }
    @catch (NSException* ex)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_PLAYLIST_PARSE_ERROR userInfo:ex.userInfo];
        return [MGMRemoteData dataWithError:error];
    }
}

- (MGMPlaylistItemDto*) playlistItemForLi:(NSDictionary*)li
{
    NSDictionary* trackUl = [li objectForKeyedSubscript:@"ul"];
    NSArray* trackLiArray = [trackUl objectForKeyedSubscript:@"li"];

    NSDictionary* titleDictionary = trackLiArray[1];
    NSString* title = [titleDictionary objectForKey:kXMLReaderTextNodeKey];
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSDictionary* artistDictionary = trackLiArray[2];
    NSString* artist = [artistDictionary objectForKey:kXMLReaderTextNodeKey];
    artist = [artist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    MGMPlaylistItemDto* playlistItem = [[MGMPlaylistItemDto alloc] init];
    playlistItem.title = title;
    playlistItem.artist = artist;
    return playlistItem;
}

@end
