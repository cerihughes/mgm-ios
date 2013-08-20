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
#define ALBUM_INFO_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=%@&mbid=%@&format=json"

@implementation MGMFetchAlbumImageUrlsOperation

- (NSString*) refreshIdentifierForData:(id)data
{
    MGMAlbum* album = data;
    return [NSString stringWithFormat:REFRESH_IDENTIFIER_ALBUM_IMAGES, album.albumMbid];
}

- (NSString*) urlForData:(id)data
{
    MGMAlbum* album = data;
    return [NSString stringWithFormat:ALBUM_INFO_URL, API_KEY, album.albumMbid];
}

- (void) convertJsonData:(NSDictionary*)json forData:(id)data completion:(FETCH_COMPLETION)completion
{
    completion([self imageUrisForJson:json], nil);
}

- (NSArray*) imageUrisForJson:(NSDictionary*)json
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
            MGMAlbumImageSize size = [IMAGE_SIZE_STRINGS indexOfObject:key];
            if (size != NSNotFound)
            {
                MGMAlbumImageUriDto* imageUri = [[MGMAlbumImageUriDto alloc] init];
                imageUri.size = size;
                imageUri.uri = value;
                [imageUris addObject:imageUri];
            }
        }
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
