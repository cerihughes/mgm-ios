//
//  MGMAllEventsGoogleSheetDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/03/2015.
//  Copyright (c) 2015 Ceri Hughes. All rights reserved.
//

#import "MGMAllEventsGoogleSheetDaoOperation.h"

#import "MGMAlbumDto.h"
#import "MGMAlbumMetadataDto.h"
#import "MGMCoreDataAccess.h"
#import "MGMEventDto.h"
#import "MGMLocalData.h"
#import "MGMRemoteData.h"
#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteJsonDataConverter.h"

@implementation MGMAllEventsGoogleSheetDaoOperation

#define REFRESH_IDENTIFIER_ALL_EVENTS_GOOGLE_SHEET @"REFRESH_IDENTIFIER_ALL_EVENTS_GOOGLE_SHEET"

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess*)coreDataAccess
{
    return [[MGMAllEventsGoogleSheetLocalDataSource alloc] initWithCoreDataAccess:coreDataAccess];
}

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return [[MGMAllEventsGoogleSheetRemoteDataSource alloc] init];
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    return REFRESH_IDENTIFIER_ALL_EVENTS_GOOGLE_SHEET;
}

@end

@implementation MGMAllEventsGoogleSheetLocalDataSource

- (oneway void) fetchLocalData:(id)key completion:(LOCAL_DATA_FETCH_COMPLETION)completion
{
    CORE_DATA_FETCH_MANY_COMPLETION block = ^(NSArray* moids, NSError* error) {
        MGMLocalData* localData = [[MGMLocalData alloc] init];
        localData.error = error;
        localData.data = moids;
        completion(localData);
    };

    if ([key isEqualToString:ALL_EVENTS_KEY])
    {
        [self.coreDataAccess fetchAllEvents:block];
    }
    else if ([key isEqualToString:ALL_CLASSIC_ALBUMS_KEY])
    {
        [self.coreDataAccess fetchAllClassicAlbums:block];
    }
    else if ([key isEqualToString:ALL_NEWLY_RELEASED_ALBUMS_KEY])
    {
        [self.coreDataAccess fetchAllNewlyReleasedAlbums:block];
    }
    else if ([key isEqualToString:ALL_EVENT_ALBUMS_KEY])
    {
        [self.coreDataAccess fetchAllEventAlbums:block];
    }
}

- (oneway void) persistRemoteData:(MGMRemoteData*)remoteData key:(id)key completion:(LOCAL_DATA_PERSIST_COMPLETION)completion
{
    [self.coreDataAccess persistEvents:remoteData.data completion:completion];
}

@end

@interface MGMAllEventsGoogleSheetRemoteDataSource () <MGMRemoteHttpDataReaderDataSource, MGMRemoteJsonDataConverterDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MGMAllEventsGoogleSheetRemoteDataSource

- (instancetype)init
{
    self = [super init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"dd/MM/yyyy";
    return self;
}

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

#pragma mark - MGMRemoteHttpDataReaderDataSource

#define EVENTS_URL @"https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values?alt=json"

- (NSString*) urlForKey:(id)key
{
    return EVENTS_URL;
}

#pragma mark - MGMRemoteJsonDataConverterDelegate

#define JSON_ELEMENT_TEXT @"$t"

#define JSON_ELEMENT_FEED @"feed"
#define JSON_ELEMENT_UPDATED @"updated"
#define JSON_ELEMENT_ENTRY @"entry"

#define JSON_ELEMENT_ID @"gsx$id"
#define JSON_ELEMENT_DATE @"gsx$date"
#define JSON_ELEMENT_PLAYLIST_ID @"gsx$playlist"

#define JSON_ELEMENT_CLASSIC_ARTIST_NAME @"gsx$classicartist"
#define JSON_ELEMENT_CLASSIC_ALBUM_NAME @"gsx$classicalbum"
#define JSON_ELEMENT_CLASSIC_MBID @"gsx$classicmbid"
#define JSON_ELEMENT_CLASSIC_SCORE @"gsx$classicscore"
#define JSON_ELEMENT_CLASSIC_SPOTIFY @"gsx$classicspotifyid"
#define JSON_ELEMENT_CLASSIC_KEYS @[JSON_ELEMENT_CLASSIC_ARTIST_NAME, JSON_ELEMENT_CLASSIC_ALBUM_NAME, JSON_ELEMENT_CLASSIC_MBID, JSON_ELEMENT_CLASSIC_SCORE, JSON_ELEMENT_CLASSIC_SPOTIFY]

#define JSON_ELEMENT_NEW_ARTIST_NAME @"gsx$newartist"
#define JSON_ELEMENT_NEW_ALBUM_NAME @"gsx$newalbum"
#define JSON_ELEMENT_NEW_MBID @"gsx$newmbid"
#define JSON_ELEMENT_NEW_SCORE @"gsx$newscore"
#define JSON_ELEMENT_NEW_SPOTIFY @"gsx$newspotifyid"
#define JSON_ELEMENT_NEW_KEYS @[JSON_ELEMENT_NEW_ARTIST_NAME, JSON_ELEMENT_NEW_ALBUM_NAME, JSON_ELEMENT_NEW_MBID, JSON_ELEMENT_NEW_SCORE, JSON_ELEMENT_NEW_SPOTIFY]

- (NSDate*) dateForString:(NSString *)jsonString
{
    return [self.dateFormatter dateFromString:jsonString];
}

- (NSString *)stringValueFromJson:(NSDictionary *)json forKey:(NSString *)key
{
    NSDictionary *object = json[key];
    NSString *string = object[JSON_ELEMENT_TEXT];
    return string.length > 0 ? string : nil;
}

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
{
    NSDictionary *feed = json[JSON_ELEMENT_FEED];
    NSString *updatedString = [self stringValueFromJson:feed forKey:JSON_ELEMENT_UPDATED];
    NSArray *entries = feed[JSON_ELEMENT_ENTRY];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:entries.count];
    for (NSDictionary *entry in entries)
    {
        NSString* eventString = [self stringValueFromJson:entry forKey:JSON_ELEMENT_ID];
        NSNumber* eventNumber = @(eventString.integerValue);
        NSString* dateString = [self stringValueFromJson:entry forKey:JSON_ELEMENT_DATE];
        NSDate* date = [self dateForString:dateString];
        NSString* playlistId = [self stringValueFromJson:entry forKey:JSON_ELEMENT_PLAYLIST_ID];

        if (eventNumber.integerValue > 0 && date) {
            MGMAlbumDto* classicAlbum = [self albumForJson:entry keys:JSON_ELEMENT_CLASSIC_KEYS];
            MGMAlbumDto* newAlbum = [self albumForJson:entry keys:JSON_ELEMENT_NEW_KEYS];
            
            MGMEventDto* event = [[MGMEventDto alloc] init];
            event.eventNumber = eventNumber;
            event.eventDate = date;
            event.playlistId = playlistId;
            event.classicAlbum = classicAlbum;
            event.newlyReleasedAlbum = newAlbum;
            
            [results addObject:event];
        }
    }

    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = [results copy];
    remoteData.checksum = updatedString;
    return remoteData;
}

- (MGMAlbumDto*) albumForJson:(NSDictionary*)json keys:(NSArray *)keys
{
    NSString* artistName = [self stringValueFromJson:json forKey:keys[0]];
    NSString* albumName = [self stringValueFromJson:json forKey:keys[1]];
    NSString* mbid = [self stringValueFromJson:json forKey:keys[2]];
    NSString* scoreString = [self stringValueFromJson:json forKey:keys[3]];
    NSString* spotifyId = [self stringValueFromJson:json forKey:keys[4]];

    if (!(artistName && albumName)) {
        return nil;
    }

    MGMAlbumDto* album = [[MGMAlbumDto alloc] init];
    album.artistName = artistName;
    album.albumName = albumName;
    album.albumMbid = mbid;
    album.score = @(scoreString.floatValue);

    if (spotifyId) {
        MGMAlbumMetadataDto* spotifyMetadata = [[MGMAlbumMetadataDto alloc] init];
        spotifyMetadata.serviceType = MGMAlbumServiceTypeSpotify;
        spotifyMetadata.value = spotifyId;
        [album.metadata addObject:spotifyMetadata];
    }

    MGMAlbumMetadataDto* lastfmMetadata = [[MGMAlbumMetadataDto alloc] init];
    lastfmMetadata.serviceType = MGMAlbumServiceTypeLastFm;
    lastfmMetadata.value = artistName;
    [album.metadata addObject:lastfmMetadata];

    return album;
}

@end
