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
    NSString* urlString = [self.serviceManager serviceAvailabilityUrlForServiceType:serviceType];
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

- (void) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)serviceType completion:(ALBUM_PLAYER_COMPLETION)completion
{
    [self.serviceManager refreshAlbum:album forServiceType:serviceType completion:^(NSError* error) {
        NSString* urlString = [self.serviceManager urlForAlbum:album forServiceType:serviceType];
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
                [self cantOpenAlbumForServiceType:serviceType];
            }
        }
        else
        {
            [self cantOpenAlbumForServiceType:serviceType];
        }
    }];
}

- (void) playPlaylist:(MGMPlaylist*)playlist onService:(MGMAlbumServiceType)serviceType completion:(ALBUM_PLAYER_COMPLETION)completion
{
    NSString* urlString = [self.serviceManager urlForPlaylist:playlist forServiceType:serviceType];
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
            [self cantOpenPlaylistForServiceType:serviceType];
        }
    }
    else
    {
        [self cantOpenPlaylistForServiceType:serviceType];
    }
}

- (void) cantOpenAlbumForServiceType:(MGMAlbumServiceType)serviceType
{
    NSString* message = [NSString stringWithFormat:@"This album cannot be opened with %@. Press the album info button for more options.", [self.ui labelForServiceType:serviceType]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Cannot Open" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void) cantOpenPlaylistForServiceType:(MGMAlbumServiceType)serviceType
{
    NSString* message = [NSString stringWithFormat:@"This playlist cannot be opened with %@.", [self.ui labelForServiceType:serviceType]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Cannot Open" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
