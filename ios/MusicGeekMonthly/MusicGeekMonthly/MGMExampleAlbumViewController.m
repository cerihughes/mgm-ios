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
#import "MGMAlbumViewUtilities.h"
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
    [MGMAlbumViewUtilities displayAlbum:exampleAlbum inAlbumView:exampleAlbumView.albumView defaultImageName:@"album3.png" error:nil];
}

- (void) gotIt
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
