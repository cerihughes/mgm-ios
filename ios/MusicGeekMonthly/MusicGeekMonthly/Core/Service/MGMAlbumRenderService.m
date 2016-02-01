//
//  MGMAlbumRenderService.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumRenderService.h"

#import "MGMAlbumImageUriDto.h"
#import "MGMErrorCodes.h"
#import "MGMLastFmConstants.h"
#import "MGMSecrets.h"
#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteJsonDataConverter.h"

@interface MGMAlbumRenderService () <MGMRemoteHttpDataReaderDataSource, MGMRemoteJsonDataConverterDelegate>

@end

@implementation MGMAlbumRenderService

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

- (oneway void) refreshAlbum:(MGMAlbum*)album completion:(ALBUM_SERVICE_COMPLETION)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self refreshAlbumImages:album completion:^(NSError* error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }];
    });
}

- (oneway void) refreshAlbumImages:(MGMAlbum*)album completion:(ALBUM_SERVICE_COMPLETION)completion
{
    if (album.searchedImages == NO && album.imageUris.count == 0)
    {
        [self fetchRemoteData:album completion:^(MGMRemoteData* remoteData) {
            if (remoteData.error)
            {
                completion(remoteData.error);
            }
            else
            {
                NSArray* imageUris = remoteData.data;
                [self.coreDataAccess addImageUris:imageUris toAlbum:album.objectID completion:^(NSError* addError) {
                    [self.coreDataAccess mainThreadRefresh:album];
                    completion(addError);
                }];
            }
        }];
    }
    else
    {
        completion(nil);
    }
}

#pragma mark - MGMRemoteHttpDataReaderDataSource

#define ALBUM_INFO_TITLES_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getInfo&api_key=%@&artist=%@&album=%@&format=json"

- (NSString *)urlForKey:(id)key
{
    MGMAlbum* album = key;
    NSString* albumName = album.albumName;
    albumName = [albumName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    NSString* artistName = album.artistName;
    artistName = [artistName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    return [NSString stringWithFormat:ALBUM_INFO_TITLES_URL, LAST_FM_API_KEY, artistName, albumName];
}

#pragma mark - MGMRemoteJsonDataConverterDelegate

- (MGMRemoteData *)convertJsonData:(NSDictionary *)json key:(id)key
{
    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];

    NSMutableArray* imageUris = [NSMutableArray array];
    NSNumber* errorJson = [json objectForKey:@"error"];
    if (errorJson)
    {
        NSString* errorMessage = [json objectForKey:@"message"];
        NSDictionary* userInfo = @{NSLocalizedDescriptionKey:errorMessage};
        remoteData.error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_LAST_FM_ERROR userInfo:userInfo];
    }

    NSDictionary* albumJson = [json objectForKey:@"album"];
    if (albumJson)
    {
        NSArray* images = [albumJson objectForKey:@"image"];
        for (NSDictionary* image in images)
        {
            NSString* key = [image objectForKey:@"size"];
            NSString* value = [image objectForKey:@"#text"];
            if (value && value.length > 0)
            {
                MGMAlbumImageSize size = [self sizeForString:key];
                if (size != MGMAlbumImageSizeNone)
                {
                    MGMAlbumImageUriDto* imageUri = [[MGMAlbumImageUriDto alloc] init];
                    imageUri.size = size;
                    imageUri.uri = value;
                    [imageUris addObject:imageUri];
                }
            }
        }
    }

    MGMAlbum* album = key;
    NSString* mbid = album.albumMbid;
    if (mbid && ![mbid hasPrefix:FAKE_MBID_PREPEND])
    {
        MGMAlbumImageUriDto* albumUri = [[MGMAlbumImageUriDto alloc] init];
        albumUri.size = MGMAlbumImageSize512;
        albumUri.uri = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, mbid, MUSIC_BRAINZ_IMAGE_500];
        [imageUris addObject:albumUri];

        albumUri = [[MGMAlbumImageUriDto alloc] init];
        albumUri.size = MGMAlbumImageSize256;
        albumUri.uri = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, mbid, MUSIC_BRAINZ_IMAGE_250];
        [imageUris addObject:albumUri];
    }

    remoteData.data = [imageUris copy];
    return remoteData;
}

- (MGMAlbumImageSize)sizeForString:(NSString *)size
{
    if ([size isEqualToString:IMAGE_SIZE_SMALL])
    {
        return MGMAlbumImageSize32;
    }
    if ([size isEqualToString:IMAGE_SIZE_MEDIUM])
    {
        return MGMAlbumImageSize64;
    }
    if ([size isEqualToString:IMAGE_SIZE_LARGE])
    {
        return MGMAlbumImageSize128;
    }
    if ([size isEqualToString:IMAGE_SIZE_EXTRA_LARGE])
    {
        return MGMAlbumImageSize256;
    }
    if ([size isEqualToString:IMAGE_SIZE_MEGA])
    {
        return MGMAlbumImageSize512;
    }
    return MGMAlbumImageSizeNone;
}

@end
