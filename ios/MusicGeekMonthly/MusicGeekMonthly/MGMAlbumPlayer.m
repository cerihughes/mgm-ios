//
//  MGMAlbumPlayer.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumPlayer.h"

#define URI_PATTERN_NONE @"%@"
#define URI_PATTERN_LASTFM @"lastfm://artist/%@/similarartists"
#define URI_PATTERN_SPOTIFY @"spotify:album:%@"
#define URI_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/%@"
#define URI_PATTERN_YOUTUBE @"http://www.youtube.com/watch?v=%@"
#define URI_PATTERN_ITUNES @"https://itunes.apple.com/gb/album/%@?uo=4"
#define URI_PATTERN_DEEZER @"deezer://www.deezer.com/album/%@"

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
    NSString* pattern = [self uriPatternForServiceType:serviceType];
    NSString* encoded = [pattern stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                [self playFetchedAlbum:updatedAlbum onService:service];
                completion(nil);
            }
        }];
    }
    else
    {
        [self playFetchedAlbum:album onService:service];
        completion(nil);
    }
}
- (void) playFetchedAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)service
{
    NSString* metadata = [album metadataForServiceType:service];
    if (metadata)
    {
        NSString* uriPattern = [self uriPatternForServiceType:service];
        NSString* uriString = [NSString stringWithFormat:uriPattern, metadata];
        NSString* encoded = [uriString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:encoded];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            NSLog(@"Opening URL: %@", url);
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"No handler for URL: %@", url);
        }
    }
}

- (NSString*) uriPatternForServiceType:(MGMAlbumServiceType)serviceType
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeLastFm:
            return URI_PATTERN_LASTFM;
        case MGMAlbumServiceTypeSpotify:
            return URI_PATTERN_SPOTIFY;
        case MGMAlbumServiceTypeWikipedia:
            return URI_PATTERN_WIKIPEDIA;
        case MGMAlbumServiceTypeYouTube:
            return URI_PATTERN_YOUTUBE;
        case MGMAlbumServiceTypeItunes:
            return URI_PATTERN_ITUNES;
        case MGMAlbumServiceTypeDeezer:
            return URI_PATTERN_DEEZER;
        default:
            return nil;
    }
}

@end
