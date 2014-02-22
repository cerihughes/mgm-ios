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
#import "MGMPlaylistDto.h"
#import "MGMPlaylistItemDto.h"
#import "MGMSpotifyConstants.h"

@interface MGMPlaylistDaoOperation ()

// TODO: Remove this when core data working properly...
@property (readonly) NSMutableArray* refreshIdentifiers;

@end

@implementation MGMPlaylistDaoOperation

#define REFRESH_IDENTIFIER_PLAYLIST @"REFRESH_IDENTIFIER_PLAYLIST_ID_%@"

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    _refreshIdentifiers = [NSMutableArray array];
    MGMLocalDataSource* localDataSource = [[MGMPlaylistLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
    MGMRemoteDataSource* remoteDataSource = [[MGMPlaylistRemoteDataSource alloc] init];
    return [super initWithCoreDataAccess:coreDataAccess localDataSource:localDataSource remoteDataSource:remoteDataSource daysBetweenRemoteFetch:7];
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    NSString* data = key;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_PLAYLIST, data];
}

- (BOOL) needsRefresh:(MGMNextUrlAccess*)nextAccess
{
    return [self.refreshIdentifiers containsObject:nextAccess.identifier] == NO;
}

- (BOOL) setNextRefresh:(NSString*)identifier inDays:(NSUInteger)days error:(NSError**)error
{
    [self.refreshIdentifiers addObject:identifier];
    return YES;
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
        NSDictionary* outerWidgetContainerDiv = [body objectForKey:@"div"][0];
        NSDictionary* widgetContainerDiv = [outerWidgetContainerDiv objectForKey:@"div"];
        NSDictionary* playerDiv = [widgetContainerDiv objectForKey:@"div"][1];
        NSString* playlistTitle = [self titleForPlayerDiv:playerDiv];
        NSDictionary* mainContainerDiv = [widgetContainerDiv objectForKey:@"div"][2];
        NSDictionary* ul = [mainContainerDiv objectForKey:@"ul"];
        NSArray* liArray = [ul objectForKey:@"li"];

        MGMRemoteData* data = [[MGMRemoteData alloc] init];
        MGMPlaylistDto* playlist = [[MGMPlaylistDto alloc] init];
        playlist.spotifyPlaylistId = key;
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
    playlistItem.title = title;
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
