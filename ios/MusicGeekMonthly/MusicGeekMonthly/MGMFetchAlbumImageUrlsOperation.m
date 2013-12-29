//
//  MGMFetchAlbumImageUrlsOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMFetchAlbumImageUrlsOperation.h"

#import "MGMAlbumImageUriDto.h"
#import "MGMLastFmConstants.h"

#define REFRESH_IDENTIFIER_ALBUM_IMAGES @"REFRESH_IDENTIFIER_ALBUM_IMAGES_%@"
#define ALBUM_INFO_MBID_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getInfo&api_key=%@&mbid=%@&format=json"
#define ALBUM_INFO_TITLES_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getInfo&api_key=%@&artist=%@&album=%@&format=json"
#define MUSIC_BRAINZ_IMAGE_URL @"http://coverartarchive.org/release/%@/front-%d.jpg"

@implementation MGMFetchAlbumImageUrlsOperation

- (NSString*) refreshIdentifierForData:(id)data
{
    MGMAlbum* album = data;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_ALBUM_IMAGES, album.albumMbid];
}

- (NSString*) urlForData:(id)data
{
    MGMAlbum* album = data;
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

- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion
{
    MGMAlbum* album = data;
    NSString* mbid = album.albumMbid;
    completion([self imageUrisForJson:json mbid:mbid], nil);
}

- (NSArray*) imageUrisForJson:(NSDictionary*)json mbid:(NSString*)mbid
{
    NSMutableArray* imageUris = [NSMutableArray array];
    NSDictionary* albumJson = [json objectForKey:@"album"];
    NSArray* images = [albumJson objectForKey:@"image"];
    for (NSDictionary* image in images)
    {
        NSString* key = [image objectForKey:@"size"];
        NSString* value = [image objectForKey:@"#text"];
        if (value && value.length > 0)
        {
            NSUInteger size = [IMAGE_SIZE_STRINGS indexOfObject:key];
            if (size != NSNotFound)
            {
                MGMAlbumImageUriDto* imageUri = [[MGMAlbumImageUriDto alloc] init];
                imageUri.size = size;
                imageUri.uri = value;
                [imageUris addObject:imageUri];
            }
        }
    }

    if (mbid && ![mbid hasPrefix:FAKE_MBID_PREPEND])
    {
        MGMAlbumImageUriDto* albumUri = [[MGMAlbumImageUriDto alloc] init];
        albumUri.size = MGMAlbumImageSizeLarge;
        albumUri.uri = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, mbid, 500];
        [imageUris addObject:albumUri];

        albumUri = [[MGMAlbumImageUriDto alloc] init];
        albumUri.size = MGMAlbumImageSizeMedium;
        albumUri.uri = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, mbid, 250];
        [imageUris addObject:albumUri];
    }

    return [imageUris copy];
}

- (void) coreDataPersistConvertedData:(id)convertedUrlData withData:(id)data completion:(VOID_COMPLETION)completion
{
    MGMAlbum* album = data;
    [self.coreDataDao addImageUris:convertedUrlData toAlbumWithMbid:album.albumMbid updateServiceType:MGMAlbumServiceTypeLastFm completion:completion];
}

- (void) coreDataFetchWithData:(id)data completion:(FETCH_COMPLETION)completion
{
    MGMAlbum* album = data;
    [self.coreDataDao fetchAlbumWithMbid:album.albumMbid completion:completion];
}

@end
