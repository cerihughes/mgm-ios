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
#import "MGMRemoteHttpDataReader.h"
#import "MGMRemoteJsonDataConverter.h"

@interface MGMAlbumRenderServiceDataReader : MGMRemoteHttpDataReader

@end

@implementation MGMAlbumRenderServiceDataReader

#define ALBUM_INFO_MBID_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getInfo&api_key=%@&mbid=%@&format=json"
#define ALBUM_INFO_TITLES_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getInfo&api_key=%@&artist=%@&album=%@&format=json"

- (NSString*) urlForKey:(id)key
{
    MGMAlbum* album = key;
    NSString* mbid = album.albumMbid;
    if (mbid && ![mbid hasPrefix:FAKE_MBID_PREPEND])
    {
        return [NSString stringWithFormat:ALBUM_INFO_MBID_URL, API_KEY, mbid];
    }
    else
    {
        NSString* albumName = album.albumName;
        albumName = [albumName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        NSString* artistName = album.artistName;
        artistName = [artistName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        return [NSString stringWithFormat:ALBUM_INFO_TITLES_URL, API_KEY, artistName, albumName];
    }
}

@end

@interface MGMAlbumRenderServiceDataConverter : MGMRemoteJsonDataConverter

@end

@implementation MGMAlbumRenderServiceDataConverter

#define MUSIC_BRAINZ_IMAGE_URL @"http://coverartarchive.org/release/%@/front-%d.jpg"

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key
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
        albumUri.uri = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, mbid, 500];
        [imageUris addObject:albumUri];

        albumUri = [[MGMAlbumImageUriDto alloc] init];
        albumUri.size = MGMAlbumImageSize256;
        albumUri.uri = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, mbid, 250];
        [imageUris addObject:albumUri];
    }

    remoteData.data = [imageUris copy];
    return remoteData;
}

- (MGMAlbumImageSize) sizeForString:(NSString*)size
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

@implementation MGMAlbumRenderService

- (MGMRemoteDataReader*) createRemoteDataReader
{
    return [[MGMAlbumRenderServiceDataReader alloc] init];
}

- (MGMRemoteDataConverter*) createRemoteDataConverter
{
    return [[MGMAlbumRenderServiceDataConverter alloc] init];
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

@end
