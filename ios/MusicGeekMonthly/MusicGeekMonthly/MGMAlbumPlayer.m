//
//  MGMAlbumPlayer.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumPlayer.h"

#import "MGMUI.h"

@implementation MGMAlbumPlayer

- (NSUInteger) determineCapabilities
{
    NSUInteger capabiliies = MGMAlbumServiceTypeNone;

    [self processCapability:MGMAlbumServiceTypeLastFm forValue:&capabiliies];
    [self processCapability:MGMAlbumServiceTypeSpotify forValue:&capabiliies];
    [self processCapability:MGMAlbumServiceTypeWikipedia forValue:&capabiliies];
    [self processCapability:MGMAlbumServiceTypeYouTube forValue:&capabiliies];
    [self processCapability:MGMAlbumServiceTypeItunes forValue:&capabiliies];
    [self processCapability:MGMAlbumServiceTypeDeezer forValue:&capabiliies];

    return capabiliies;
}

- (BOOL) hasCapability:(MGMAlbumServiceType)serviceType
{
    MGMAlbumMetadataDao* dao = [self.daoFactory metadataDaoForServiceType:serviceType];
    NSString* urlString = [dao serviceAvailabilityUrl];
    NSString* encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:encoded];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

- (void) processCapability:(MGMAlbumServiceType)serviceType forValue:(NSUInteger*)value
{
    if ([self hasCapability:serviceType])
    {
        *value |= serviceType;
    }
}

- (void) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)service completion:(VOID_COMPLETION)completion
{
    MGMAlbumMetadataDao* dao = [self.daoFactory metadataDaoForServiceType:service];
    if (dao && [album searchedServiceType:service] == NO)
    {
        NSLog(@"Updating album metadata: %@ - %@", album.artistName, album.albumName);
        [dao updateAlbumInfo:album completion:^(MGMAlbum* updatedAlbum, NSError* updateError)
        {
            if (updateError && !updatedAlbum)
            {
                completion(updateError);
            }
            else
            {
                [self playFetchedAlbum:updatedAlbum dao:dao];
                completion(nil);
            }
        }];
    }
    else
    {
        [self playFetchedAlbum:album dao:dao];
        completion(nil);
    }
}
- (void) playFetchedAlbum:(MGMAlbum*)album dao:(MGMAlbumMetadataDao*)dao
{
    NSString* urlString = [dao urlForAlbum:album];
    if (urlString)
    {
        NSString* encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:encoded];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            NSLog(@"Opening URL: %@", url);
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"No handler for URL: %@", url);
            [self cantOpenUrlForDao:dao];
        }
    }
    else
    {
        [self cantOpenUrlForDao:dao];
    }
}

- (void) cantOpenUrlForDao:(MGMAlbumMetadataDao*)dao
{
    MGMAlbumServiceType serviceType = dao.serviceType;
    NSString* message = [NSString stringWithFormat:@"This album cannot be opened with %@. Press the album info button for more options.", [self.ui labelForServiceType:serviceType]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Cannot Open" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
