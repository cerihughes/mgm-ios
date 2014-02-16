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

- (void) displayAlbumDto:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        albumView.activityInProgress = YES;
        albumView.artistName = album.artistName;
        albumView.albumName = album.albumName;
        albumView.score = [album.score floatValue];
    });

    MGMAlbumImageSize preferredSize = [self preferredImageSizeForViewSize:albumView.frame.size];
    NSArray* albumArtUrls = [self bestAlbumImageUrlsForAlbum:album preferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView defaultImageName:defaultName error:error];
}

- (NSArray*) bestAlbumImageUrlsForAlbum:(MGMAlbumDto*)album preferredSize:(MGMAlbumImageSize)size
{
    NSMutableArray* array = [NSMutableArray array];

    MGMAlbumImageSize sizes[6] = {size, MGMAlbumImageSize128, MGMAlbumImageSize256, MGMAlbumImageSize512, MGMAlbumImageSize64, MGMAlbumImageSize32};
    for (NSUInteger i = 0; i < 6; i++)
    {
        for (MGMAlbumImageUriDto* uri in album.imageUris)
        {
            if (uri.size == sizes[i])
            {
                [array addObject:uri.uri];
            }
        }
    }

    return [array copy];
}

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        albumView.activityInProgress = YES;
        albumView.artistName = album.artistName;
        albumView.albumName = album.albumName;
        albumView.score = [album.score floatValue];
    });

    [self.renderService refreshAlbumImages:album error:error];
    [self displayAlbumImage:album inAlbumView:albumView defaultImageName:defaultName error:error];
}

- (void) displayAlbumImage:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error
{
    MGMAlbumImageSize preferredSize = [self preferredImageSizeForViewSize:albumView.frame.size];
    NSArray* albumArtUrls = [album bestAlbumImageUrlsWithPreferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView defaultImageName:defaultName error:error];
}

- (void) displayAlbumImages:(NSArray*)albumArtUrls inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error
{
    if (albumArtUrls.count > 0)
    {
        [self.imageHelper asyncImageFromUrls:albumArtUrls completion:^(UIImage* image, NSError* imageError)
         {
             if (imageError)
             {
                 *error = imageError;
             }
             else
             {
                 if (image == nil)
                 {
                     image = [UIImage imageNamed:defaultName];
                 }
                 [self renderImage:image inAlbumView:albumView];
             }
         }];
    }
    else
    {
        [self renderImage:[UIImage imageNamed:defaultName] inAlbumView:albumView];
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
