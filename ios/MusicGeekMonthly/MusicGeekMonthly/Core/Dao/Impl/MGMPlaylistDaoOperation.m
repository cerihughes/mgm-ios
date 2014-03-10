//
//  MGMPlaylistDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 22/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMPlaylistDaoOperation.h"

#import "MGMAlbumImageUriDto.h"
#import "MGMErrorCodes.h"
#import "MGMPlaylist.h"
#import "MGMPlaylistDto.h"
#import "MGMPlaylistItem.h"
#import "MGMPlaylistItemDto.h"
#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteXmlDataConverter.h"
#import "MGMSpotifyConstants.h"

@implementation MGMPlaylistDaoOperation

#define REFRESH_IDENTIFIER_PLAYLIST @"REFRESH_IDENTIFIER_PLAYLIST_ID_%@"

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess*)coreDataAccess
{
    return [[MGMPlaylistLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
}

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMPlaylistRemoteDataSource alloc] init];
}

- (NSUInteger) daysBetweenRemoteFetch
{
    return 7;
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    NSString* data = key;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_PLAYLIST, data];
}

@end

@implementation MGMPlaylistLocalDataSource

- (MGMLocalData*) fetchLocalData:(id)key
{
    MGMLocalData* localData = [[MGMLocalData alloc] init];
    NSError* error = nil;
    localData.data = [self.coreDataAccess fetchPlaylistWithId:key error:&error];
    localData.error = error;
    return localData;
}

- (BOOL) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key error:(NSError**)error
{
    return [self.coreDataAccess persistPlaylist:remoteData.data error:error];
}

@end

@interface MGMPlaylistRemoteDataReader : MGMRemoteHttpDataReader

@end

@implementation MGMPlaylistRemoteDataReader

#define EMBEDDED_PLAYLIST_URL @"https://embed.spotify.com/?uri=%@"

- (NSString*) urlForKey:(id)key
{
    NSString* data = key;
    NSString* spotifyUrl = [NSString stringWithFormat:SPOTIFY_PLAYLIST_URI_PATTERN, SPOTIFY_USER_ANDREW_JONES, data];
    return [NSString stringWithFormat:EMBEDDED_PLAYLIST_URL, spotifyUrl];
}

@end

@interface MGMPlaylistRemoteDataConverter : MGMRemoteXmlDataConverter

@end

@implementation MGMPlaylistRemoteDataConverter

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
        NSDictionary* outerWidgetContainerDiv = [body objectForKey:@"div"][0];
        NSDictionary* widgetContainerDiv = [outerWidgetContainerDiv objectForKey:@"div"];
        NSDictionary* playerDiv = [widgetContainerDiv objectForKey:@"div"][1];
        NSString* playlistTitle = [self titleForPlayerDiv:playerDiv];
        NSDictionary* mainContainerDiv = [widgetContainerDiv objectForKey:@"div"][2];
        NSDictionary* ul = [mainContainerDiv objectForKey:@"ul"];
        NSArray* liArray = [ul objectForKey:@"li"];

        MGMRemoteData* data = [[MGMRemoteData alloc] init];
        MGMPlaylistDto* playlist = [[MGMPlaylistDto alloc] init];
        playlist.playlistId = key;
        playlist.name = playlistTitle;
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

- (NSString*) titleForPlayerDiv:(NSDictionary*)playerDiv
{
    NSDictionary* metaDiv = [playerDiv objectForKey:@"div"][2];
    NSDictionary* progressBarContainerDiv = [metaDiv objectForKey:@"div"][2];
    NSDictionary* contextTitleDiv = [progressBarContainerDiv objectForKey:@"div"][1];
    NSDictionary* titleContentDiv = [contextTitleDiv objectForKey:@"div"][1];
    NSString* title = [titleContentDiv objectForKey:kXMLReaderTextNodeKey];
    return [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (MGMPlaylistItemDto*) playlistItemForLi:(NSDictionary*)li
{
    NSString* smallUrl = [li objectForKey:@"data-small-ca"];
    NSString* largeUrl = [li objectForKey:@"data-ca"];

    NSDictionary* trackUl = [li objectForKeyedSubscript:@"ul"];
    NSArray* trackLiArray = [trackUl objectForKeyedSubscript:@"li"];

    NSDictionary* titleDictionary = trackLiArray[1];
    NSString* title = [titleDictionary objectForKey:kXMLReaderTextNodeKey];
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSDictionary* artistDictionary = trackLiArray[2];
    NSString* artist = [artistDictionary objectForKey:kXMLReaderTextNodeKey];
    artist = [artist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    MGMPlaylistItemDto* playlistItem = [[MGMPlaylistItemDto alloc] init];
    playlistItem.track = title;
    playlistItem.artist = artist;

    MGMAlbumImageUriDto* smallImageUri = [[MGMAlbumImageUriDto alloc] init];
    smallImageUri.uri = smallUrl;
    smallImageUri.size = MGMAlbumImageSize128;

    MGMAlbumImageUriDto* largeImageUri = [[MGMAlbumImageUriDto alloc] init];
    largeImageUri.uri = largeUrl;
    largeImageUri.size = MGMAlbumImageSize512;

    [playlistItem.imageUris addObject:smallImageUri];
    [playlistItem.imageUris addObject:largeImageUri];

    return playlistItem;
}

@end

@implementation MGMPlaylistRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    return [[MGMPlaylistRemoteDataReader alloc] init];
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    return [[MGMPlaylistRemoteDataConverter alloc] init];
}

@end
