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
#import "MGMXmlParser.h"

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

- (oneway void) fetchLocalData:(id)key completion:(LOCAL_DATA_FETCH_COMPLETION)completion
{
    [self.coreDataAccess fetchPlaylistWithId:key completion:^(NSManagedObjectID* moid, NSError* error) {
        MGMLocalData* localData = [[MGMLocalData alloc] init];
        localData.error = error;
        localData.data = moid;
        completion(localData);
    }];
}

- (oneway void) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key completion:(LOCAL_DATA_PERSIST_COMPLETION)completion
{
    [self.coreDataAccess persistPlaylist:remoteData.data completion:completion];
}

@end

@interface MGMPlaylistRemoteDataSource () <MGMRemoteHttpDataReaderDataSource, MGMRemoteXmlDataConverterDelegate>

@end

@implementation MGMPlaylistRemoteDataSource

- (MGMRemoteDataReader*) createRemoteDataReader
{
    MGMRemoteHttpDataReader *reader = [[MGMRemoteHttpDataReader alloc] init];
    reader.dataSource = self;
    return reader;
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    MGMRemoteXmlDataConverter *converter = [[MGMRemoteXmlDataConverter alloc] init];
    converter.delegate = self;
    return converter;
}

#pragma mark - MGMRemoteHttpDataReaderDataSource

#define EMBEDDED_PLAYLIST_URL @"https://embed.spotify.com/?uri=%@"

- (NSString*) urlForKey:(id)key
{
    NSString* data = key;
    NSString* spotifyUrl = [NSString stringWithFormat:SPOTIFY_PLAYLIST_URI_PATTERN, SPOTIFY_USER_ANDREW_JONES, data];
    return [NSString stringWithFormat:EMBEDDED_PLAYLIST_URL, spotifyUrl];
}

#pragma mark - MGMRemoteXmlDataConverterDelegate

- (NSData *)preprocessRemoteData:(NSData *)remoteData
{
    NSString* string = [[NSString alloc] initWithData:remoteData encoding:NSUTF8StringEncoding];

    // Remove erroneous meta tags...
    string = [string stringByReplacingOccurrencesOfString:@"<meta charset=\"UTF-8\">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</meta>" withString:@""];

    // Tidy up ampersands
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;amp;" withString:@"&amp;"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (MGMRemoteData *)convertXmlData:(NSDictionary *)xml key:(id)key
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

        NSString* checksum = @"";
        for (NSDictionary* li in liArray)
        {
            MGMPlaylistItemDto* playlistItem = [self playlistItemForLi:li];
            [playlist.playlistItems addObject:playlistItem];
            checksum = [checksum stringByAppendingString:playlistItem.duration];
            checksum = [checksum stringByAppendingString:@"-"];
        }
        data.data = playlist;
        data.checksum = checksum;
        return data;
    }
    @catch (NSException* ex)
    {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_PLAYLIST_PARSE_ERROR userInfo:ex.userInfo];
        return [MGMRemoteData dataWithError:error];
    }
}

- (NSString *)titleForPlayerDiv:(NSDictionary *)playerDiv
{
    NSDictionary* metaDiv = [playerDiv objectForKey:@"div"][2];
    NSDictionary* progressBarContainerDiv = [metaDiv objectForKey:@"div"][2];
    NSDictionary* contextTitleDiv = [progressBarContainerDiv objectForKey:@"div"][1];
    NSDictionary* titleContentDiv = [contextTitleDiv objectForKey:@"div"][1];
    NSString* title = [titleContentDiv objectForKey:kXMLReaderTextNodeKey];
    return [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (MGMPlaylistItemDto *)playlistItemForLi:(NSDictionary *)li
{
    NSString* smallUrl = [li objectForKey:@"data-small-ca"];
    NSString* largeUrl = [li objectForKey:@"data-ca"];
    NSString* duration = [li objectForKey:@"data-duration"];

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
    playlistItem.duration = duration;

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
