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

@implementation MGMAlbumViewUtilities

+ (void) displayAlbum:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        albumView.activityInProgress = YES;
        albumView.artistName = album.artistName;
        albumView.albumName = album.albumName;
        albumView.score = [album.score floatValue];
    });

    NSArray* albumArtUrls = [self bestAlbumImageUrlsForAlbum:album];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView defaultImageName:defaultName error:error];
}

+ (NSArray*) bestAlbumImageUrlsForAlbum:(MGMAlbumDto*)album
{
    NSMutableArray* array = [NSMutableArray array];

    MGMAlbumImageSize sizes[5] = {MGMAlbumImageSize128, MGMAlbumImageSize256, MGMAlbumImageSize512, MGMAlbumImageSize64, MGMAlbumImageSize32};
    for (NSUInteger i = 0; i < 5; i++)
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

+ (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName daoFactory:(MGMDaoFactory*)daoFactory error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        albumView.activityInProgress = YES;
        albumView.artistName = album.artistName;
        albumView.albumName = album.albumName;
        albumView.score = [album.score floatValue];
    });

    if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        [daoFactory.lastFmDao updateAlbumInfo:album completion:^(MGMAlbum* updatedAlbum, NSError* updateError)
        {
            if (updateError)
            {
                *error = updateError;
            }
            else
            {
                [MGMAlbumViewUtilities displayAlbumImage:updatedAlbum inAlbumView:albumView defaultImageName:defaultName error:error];
            }
        }];
    }
    else
    {
        [MGMAlbumViewUtilities displayAlbumImage:album inAlbumView:albumView defaultImageName:defaultName error:error];
    }
}

+ (void) displayAlbumImage:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error
{
    NSArray* albumArtUrls = [album bestAlbumImageUrls];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView defaultImageName:defaultName error:error];
}

+ (void) displayAlbumImages:(NSArray*)albumArtUrls inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName error:(NSError**)error
{
    if (albumArtUrls.count > 0)
    {
        [MGMImageHelper asyncImageFromUrls:albumArtUrls completion:^(UIImage* image, NSError* imageError)
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
                 [MGMAlbumViewUtilities renderImage:image inAlbumView:albumView];
             }
         }];
    }
    else
    {
        [MGMAlbumViewUtilities renderImage:[UIImage imageNamed:defaultName] inAlbumView:albumView];
    }
}

+ (void) renderImage:(UIImage*)image inAlbumView:(MGMAlbumView*)albumView
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        albumView.activityInProgress = NO;
        [albumView renderImage:image];
    });
}

@end
