//
//  MGMAlbumViewUtilities.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 07/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumViewUtilities.h"

#import "MGMAlbumImageUriDto.h"
#import "MGMImageHelper.h"

@interface MGMAlbumViewUtilities ()

@property (readonly) MGMImageHelper* imageHelper;
@property (readonly) MGMAlbumRenderService* renderService;

@end

@implementation MGMAlbumViewUtilities

- (id) initWithImageHelper:(MGMImageHelper*)imageHelper renderService:(MGMAlbumRenderService *)renderService
{
    if (self = [super init])
    {
        _imageHelper = imageHelper;
        _renderService = renderService;
    }
    return self;
}

- (MGMAlbumImageSize) preferredImageSizeForViewSize:(CGSize)viewSize
{
    CGFloat width = viewSize.width;
    if (width > 512)
    {
        return MGMAlbumImageSize512;
    }
    if (width > 256)
    {
        return MGMAlbumImageSize256;
    }
    else if (width > 128)
    {
        return MGMAlbumImageSize128;
    }
    else if (width > 64)
    {
        return MGMAlbumImageSize64;
    }
    else if (width > 32)
    {
        return MGMAlbumImageSize32;
    }
    return MGMAlbumImageSizeNone;
}

- (void) displayAlbumDto:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        albumView.activityInProgress = YES;
        albumView.artistName = album.artistName;
        albumView.albumName = album.albumName;
        albumView.score = [album.score floatValue];
    });

    MGMAlbumImageSize preferredSize = [self preferredImageSizeForViewSize:albumView.frame.size];
    NSArray* albumArtUrls = [self bestImageUrlsForAlbum:album preferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView error:error];
}

- (void) displayPlaylistItemDto:(MGMPlaylistItemDto*)playlistItem inAlbumView:(MGMAlbumView*)albumView error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        albumView.activityInProgress = YES;
        albumView.rank = 0;
    });

    MGMAlbumImageSize preferredSize = [self preferredImageSizeForViewSize:albumView.frame.size];
    NSArray* albumArtUrls = [self bestImageUrlsForPlaylistItem:playlistItem preferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView error:error];
}

- (NSArray*) bestImageUrlsForAlbum:(MGMAlbumDto*)album preferredSize:(MGMAlbumImageSize)size
{
    return [self bestAlbumImageUrlsForAlbumImageUris:album.imageUris preferredSize:size];
}

- (NSArray*) bestImageUrlsForPlaylistItem:(MGMPlaylistItemDto*)playlistItem preferredSize:(MGMAlbumImageSize)size
{
    return [self bestAlbumImageUrlsForAlbumImageUris:playlistItem.imageUris preferredSize:size];
}

- (NSArray*) bestAlbumImageUrlsForAlbumImageUris:(NSArray*)imageUriDtos preferredSize:(MGMAlbumImageSize)size
{
    NSMutableArray* array = [NSMutableArray array];

    MGMAlbumImageSize sizes[6] = {size, MGMAlbumImageSize128, MGMAlbumImageSize256, MGMAlbumImageSize512, MGMAlbumImageSize64, MGMAlbumImageSize32};
    for (NSUInteger i = 0; i < 6; i++)
    {
        for (MGMAlbumImageUriDto* uri in imageUriDtos)
        {
            if (uri.size == sizes[i])
            {
                [array addObject:uri.uri];
            }
        }
    }

    return [array copy];
}

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView error:(NSError**)error
{
    [self displayAlbum:album inAlbumView:albumView rank:0 listeners:0 error:error];
}

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView rank:(NSUInteger)rank error:(NSError**)error
{
    [self displayAlbum:album inAlbumView:albumView rank:rank listeners:0 error:error];
}

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView rank:(NSUInteger)rank listeners:(NSUInteger)listeners error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        albumView.activityInProgress = YES;
        albumView.artistName = album.artistName;
        albumView.albumName = album.albumName;
        albumView.score = [album.score floatValue];
        albumView.rank = rank;
        albumView.listeners = listeners;
    });

    [self.renderService refreshAlbumImages:album error:error];
    [self displayAlbumImage:album inAlbumView:albumView error:error];
}

- (void) displayAlbumImage:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView error:(NSError**)error
{
    MGMAlbumImageSize preferredSize = [self preferredImageSizeForViewSize:albumView.frame.size];
    NSArray* albumArtUrls = [album bestAlbumImageUrlsWithPreferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView error:error];
}

- (void) displayAlbumImages:(NSArray*)albumArtUrls inAlbumView:(MGMAlbumView*)albumView error:(NSError**)error
{
    if (albumArtUrls.count > 0)
    {
        [self.imageHelper asyncImageFromUrls:albumArtUrls completion:^(UIImage* image, NSError* imageError) {
            if (imageError)
            {
                if (error)
                {
                    *error = imageError;
                }
            }
            if (image == nil)
            {
                image = [self.imageHelper nextDefaultImage];
            }
            [self renderImage:image inAlbumView:albumView];
        }];
    }
    else
    {
        [self renderImage:[self.imageHelper nextDefaultImage] inAlbumView:albumView];
    }
}

- (void) renderImage:(UIImage*)image inAlbumView:(MGMAlbumView*)albumView
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        albumView.activityInProgress = NO;
        [albumView renderImage:image];
    });
}

@end
