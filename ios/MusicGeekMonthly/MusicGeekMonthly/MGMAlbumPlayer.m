//
//  MGMAlbumPlayer.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumPlayer.h"

#define URI_PATTERN_LASTFM @"http://www.youtube.com/watch?v=%@"
#define URI_PATTERN_SPOTIFY @"spotify:album:%@"
#define URI_PATTERN_WIKIPEDIA @"http://en.wikipedia.org/wiki/%@"
#define URI_PATTERN_YOUTUBE @"http://www.youtube.com/watch?v=%@"

@interface MGMAlbumPlayer ()

@property (strong) NSArray* patterns;

@end

@implementation MGMAlbumPlayer

- (id) init
{
    if (self = [super init])
    {
        self.patterns = @[URI_PATTERN_LASTFM, URI_PATTERN_SPOTIFY, URI_PATTERN_WIKIPEDIA, URI_PATTERN_YOUTUBE];
    }
    return self;
}

- (void) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)service
{
    if ([album searchedServiceType:service] == NO)
    {
        NSLog(@"Updating album metadata: %@ - %@", album.artistName, album.albumName);
        MGMAlbumMetadataDao* dao = [self.daoFactory metadataDaoForServiceType:service];
        [dao updateAlbumInfo:album];
        [album setServiceTypeSearched:service];
    }
    
    NSString* metadata = [album metadataForServiceType:service];
    if (metadata)
    {
        NSString* uriPattern = [self.patterns objectAtIndex:service];
        NSString* uriString = [NSString stringWithFormat:uriPattern, metadata];
        NSURL* url = [NSURL URLWithString:uriString];
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

@end
