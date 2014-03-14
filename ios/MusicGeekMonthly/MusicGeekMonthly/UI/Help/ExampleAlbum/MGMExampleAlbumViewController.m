//
//  MGMExampleAlbumViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMExampleAlbumViewController.h"

#import "MGMAlbumDto.h"
#import "MGMAlbumImageUriDto.h"
#import "MGMAlbumMetadataDto.h"
#import "MGMExampleAlbumView.h"

@interface MGMExampleAlbumViewController () <MGMExampleAlbumViewDelegate>

@end

@implementation MGMExampleAlbumViewController

- (void) loadView
{
    [super loadView];

    MGMExampleAlbumView* exampleAlbumView = [[MGMExampleAlbumView alloc] initWithFrame:[self fullscreenRect]];
    exampleAlbumView.delegate = self;

    self.view = exampleAlbumView;
}

- (void) viewDidLoad
{
    [self loadExampleAlbum];
}

- (MGMAlbumDto*) createExampleData
{
    NSString* mbid = @"598385f8-4cfd-49cf-9e25-ceb3c464d9b3";
    MGMAlbumDto* exampleAlbum = [[MGMAlbumDto alloc] init];
    exampleAlbum.albumMbid = mbid;
    exampleAlbum.albumName = @"Takk...";
    exampleAlbum.artistName = @"Sigur Rós";

    MGMAlbumImageUriDto* uri = [[MGMAlbumImageUriDto alloc] init];
    uri.size = MGMAlbumImageSize256;
    uri.uri = @"http://userserve-ak.last.fm/serve/300x300/30803371.png";
    [exampleAlbum.imageUris addObject:uri];

    uri = [[MGMAlbumImageUriDto alloc] init];
    uri.size = MGMAlbumImageSize128;
    uri.uri = @"http://userserve-ak.last.fm/serve/126/30803371.png";
    [exampleAlbum.imageUris addObject:uri];

    MGMAlbumMetadataDto* lastfmMetadata = [[MGMAlbumMetadataDto alloc] init];
    lastfmMetadata.serviceType = MGMAlbumServiceTypeLastFm;
    lastfmMetadata.value = mbid;
    [exampleAlbum.metadata addObject:lastfmMetadata];

    MGMAlbumMetadataDto* spotifyMetadata = [[MGMAlbumMetadataDto alloc] init];
    spotifyMetadata.serviceType = MGMAlbumServiceTypeSpotify;
    spotifyMetadata.value = @"3sE83l3A58DipFp3EzNLiE";
    [exampleAlbum.metadata addObject:spotifyMetadata];

    MGMAlbumMetadataDto* wikipediaMetadata = [[MGMAlbumMetadataDto alloc] init];
    wikipediaMetadata.serviceType = MGMAlbumServiceTypeWikipedia;
    wikipediaMetadata.value = @"Takk...";
    [exampleAlbum.metadata addObject:wikipediaMetadata];

    MGMAlbumMetadataDto* youtubeMetadata = [[MGMAlbumMetadataDto alloc] init];
    youtubeMetadata.serviceType = MGMAlbumServiceTypeYouTube;
    youtubeMetadata.value = @"ojLgN7wqc5A";
    [exampleAlbum.metadata addObject:youtubeMetadata];

    MGMAlbumMetadataDto* itunesMetadata = [[MGMAlbumMetadataDto alloc] init];
    itunesMetadata.serviceType = MGMAlbumServiceTypeItunes;
    itunesMetadata.value = @"id697318976";
    [exampleAlbum.metadata addObject:itunesMetadata];

    MGMAlbumMetadataDto* deezerMetadata = [[MGMAlbumMetadataDto alloc] init];
    deezerMetadata.serviceType = MGMAlbumServiceTypeDeezer;
    deezerMetadata.value = @"300782";
    [exampleAlbum.metadata addObject:deezerMetadata];
    
    return exampleAlbum;
}

- (void) loadExampleAlbum
{
    MGMExampleAlbumView* exampleAlbumView = (MGMExampleAlbumView*)self.view;
    MGMAlbumDto* exampleAlbum = [self createExampleData];
    [self displayAlbumDto:exampleAlbum inAlbumView:exampleAlbumView.albumView];
}

- (void) displayAlbumDto:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView
{
    albumView.activityInProgress = YES;
    albumView.artistName = album.artistName;
    albumView.albumName = album.albumName;
    albumView.score = [album.score floatValue];

    MGMAlbumImageSize preferredSize = preferredImageSize(albumView.frame.size);
    NSArray* albumArtUrls = [self bestImageUrlsForAlbum:album preferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView completion:^(NSError* error) {}];
}

- (NSArray*) bestImageUrlsForAlbum:(MGMAlbumDto*)album preferredSize:(MGMAlbumImageSize)size
{
    return [self bestAlbumImageUrlsForAlbumImageUris:album.imageUris preferredSize:size];
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

- (void) gotIt
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
