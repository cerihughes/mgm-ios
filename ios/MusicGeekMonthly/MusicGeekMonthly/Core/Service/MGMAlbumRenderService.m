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

@interface MGMAlbumRenderService ()

@property (readonly) MGMCoreDataAccess* coreDataAccess;

@end

@implementation MGMAlbumRenderService

#define ALBUM_INFO_MBID_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getInfo&api_key=%@&mbid=%@&format=json"
#define ALBUM_INFO_TITLES_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getInfo&api_key=%@&artist=%@&album=%@&format=json"
#define MUSIC_BRAINZ_IMAGE_URL @"http://coverartarchive.org/release/%@/front-%d.jpg"

- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess
{
    if (self = [super init])
    {
        _coreDataAccess = coreDataAccess;
    }
    return self;
}

- (BOOL) refreshAlbumImages:(MGMAlbum*)album error:(NSError**)error
{
    if (album.searchedImages == NO && album.imageUris.count == 0)
    {
        NSArray* imageUris = [self imageUrlsForAlbum:album];
        [self.coreDataAccess addImageUris:imageUris toAlbum:album error:error];
        return MGM_NO_ERROR(&error);
    }
    return YES;
}

- (NSArray*) imageUrlsForAlbum:(MGMAlbum *)album
{
    MGMRemoteData* remoteData = [self fetchRemoteData:album];
    return remoteData.data;
}

#pragma mark -
#pragma mark MGMRemoteDataSource

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
