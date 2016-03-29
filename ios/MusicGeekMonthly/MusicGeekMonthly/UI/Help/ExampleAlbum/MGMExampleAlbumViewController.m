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
#import "MGMAlbumView.h"
#import "MGMLastFmConstants.h"

@interface MGMExampleAlbumViewController () <MGMExampleAlbumViewDelegate, MGMModalViewDelegate>

@end

@implementation MGMExampleAlbumViewController

- (void) loadView
{
    [super loadView];

    CGRect frame = [self fullscreenRect];

    Class viewClass = mgm_isIpad() ? [MGMExampleAlbumViewPad class] : [MGMExampleAlbumViewPhone class];
    MGMExampleAlbumView* view = [[viewClass alloc] initWithFrame:frame];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.delegate = self;

    MGMModalView *modalView = mgm_isIpad() ?
        [[MGMModalViewPad alloc] initWithFrame:frame buttonTitle:@"Got it!" contentView:view] :
        [[MGMModalViewPhone alloc] initWithFrame:frame navigationTitle:@"Album Example" buttonTitle:@"Got it!" contentView:view];

    modalView.delegate = self;

    self.view = modalView;
}

- (void) viewDidLoad
{
    [self loadExampleAlbum];
}

- (MGMAlbumDto*) createExampleData
{
    NSString* mbid = @"eb03ba58-e017-492f-8d50-5e016075f2bd";
    MGMAlbumDto* exampleAlbum = [[MGMAlbumDto alloc] init];
    exampleAlbum.albumMbid = mbid;
    exampleAlbum.albumName = @"Takk...";
    exampleAlbum.artistName = @"Sigur Rós";

    MGMAlbumImageUriDto* uri = [[MGMAlbumImageUriDto alloc] init];
    uri.size = MGMAlbumImageSize256;
    uri.uri = [NSString stringWithFormat:MUSIC_BRAINZ_IMAGE_URL, mbid, MUSIC_BRAINZ_IMAGE_250];
    [exampleAlbum.imageUris addObject:uri];

    uri = [[MGMAlbumImageUriDto alloc] init];
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
    MGMAlbumDto* exampleAlbum = [self createExampleData];
    [self displayAlbumDto:exampleAlbum inAlbumView:self.view.contentView.albumView];
}

- (void) displayAlbumDto:(MGMAlbumDto*)album inAlbumView:(MGMAlbumView*)albumView
{
    albumView.activityInProgress = YES;
    albumView.artistName = album.artistName;
    albumView.albumName = album.albumName;
    albumView.score = [album.score floatValue];

    MGMAlbumImageSize preferredSize = preferredImageSize(albumView.frame.size, self.screenScale);
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

#pragma mark - MGMExampleAlbumViewDelegate

- (void)gotIt
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MGMModalViewDelegate

- (void)modalButtonPressed
{
    [self gotIt];
}

@end
