//
//  MGMAlbumViewUtilities.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 07/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumViewUtilities.h"

#import "MGMImageHelper.h"

@implementation MGMAlbumViewUtilities

+ (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView defaultImageName:(NSString*)defaultName daoFactory:(MGMDaoFactory*)daoFactory error:(NSError**)error
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
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
    NSString* albumArtUri = [album bestAlbumImageUrl];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage* image, NSError* imageError)
        {
            if (imageError)
            {
                *error = imageError;
            }
            else
            {
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
