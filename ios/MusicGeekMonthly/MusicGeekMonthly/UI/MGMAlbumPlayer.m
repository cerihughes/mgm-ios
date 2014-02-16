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

- (BOOL) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)serviceType error:(NSError**)error;
{
    [self.serviceManager refreshAlbumMetadata:album forServiceType:serviceType error:error];
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
            [self cantOpenUrlForServiceType:serviceType];
        }
    }
    else
    {
        [self cantOpenUrlForServiceType:serviceType];
    }
    return MGM_NO_ERROR(&error);
}

- (void) cantOpenUrlForServiceType:(MGMAlbumServiceType)serviceType
{
    NSString* message = [NSString stringWithFormat:@"This album cannot be opened with %@. Press the album info button for more options.", [self.ui labelForServiceType:serviceType]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Cannot Open" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
