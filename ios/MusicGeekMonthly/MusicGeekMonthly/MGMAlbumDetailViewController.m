//
//  MGMAlbumDetailViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 25/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailViewController.h"

#import "MGMAlbum.h"
#import "MGMAlbumDetailView.h"
#import "MGMAlbumViewUtilities.h"

#define CELL_ID @"ALBUM_DETAIL_CELL_ID"

@interface MGMKeyValuePair : NSObject

@property MGMAlbumServiceType serviceType;
@property (strong) NSString* displayString;

@end

@implementation MGMKeyValuePair

@end

@interface MGMAlbumDetailViewController () <UITableViewDataSource, UITableViewDelegate, MGMAlbumDetailViewDelegate>

@property (strong) NSArray* keyValuePairs;

@end

@implementation MGMAlbumDetailViewController

- (void) loadView
{
    MGMAlbumDetailView* detailView = [[MGMAlbumDetailView alloc] initWithFrame:[self fullscreenRect]];
    detailView.delegate = self;
    detailView.tableView.dataSource = self;
    detailView.tableView.delegate = self;
    
    self.view = detailView;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    MGMAlbumDetailView* detailView = (MGMAlbumDetailView*)self.view;

    MGMAlbum* album = [self.core.daoFactory.coreDataDao threadVersion:self.albumMoid];
    NSError* error = nil;
    [MGMAlbumViewUtilities displayAlbum:album inAlbumView:detailView.albumView defaultImageName:@"album2.png" daoFactory:self.core.daoFactory error:&error];
    if (error)
    {
        [self logError:error];
    }

    self.keyValuePairs = [self optionsForAlbum:album];
    [detailView.tableView reloadData];
}

- (NSArray*) optionsForAlbum:(MGMAlbum*)album
{
    NSMutableArray* array = [NSMutableArray array];
    for (MGMAlbumMetadata* metadata in album.metadata)
    {
        NSString* displayString = [self stringForServiceType:metadata.serviceType album:album];
        if (displayString)
        {
            MGMKeyValuePair* pair = [[MGMKeyValuePair alloc] init];
            pair.serviceType = metadata.serviceType;
            pair.displayString = displayString;
            [array addObject:pair];
        }
    }

    // We implicitly support last.fm and spotify...
    MGMKeyValuePair* lastFmPair = [[MGMKeyValuePair alloc] init];
    lastFmPair.serviceType = MGMAlbumServiceTypeLastFm;
    lastFmPair.displayString = [NSString stringWithFormat:@"Play %@ radio with Last.fm", album.artistName];
    [array addObject:lastFmPair];

    MGMKeyValuePair* spotifyPair = [[MGMKeyValuePair alloc] init];
    spotifyPair.serviceType = MGMAlbumServiceTypeSpotify;
    spotifyPair.displayString = @"Play with Spotify";
    [array addObject:spotifyPair];

    NSArray* sorted = [array sortedArrayUsingComparator:^NSComparisonResult(MGMKeyValuePair* a, MGMKeyValuePair* b)
    {
        NSNumber* first = [NSNumber numberWithInteger:a.serviceType];
        NSNumber* second = [NSNumber numberWithInteger:b.serviceType];
        return [first compare:second];
    }];
    return sorted;
}

- (NSString*) stringForServiceType:(MGMAlbumServiceType)serviceType album:(MGMAlbum*)album
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeWikipedia:
            return @"Read Wikipedia article";
        case MGMAlbumServiceTypeYouTube:
            return @"Play with YouTube";
        case MGMAlbumServiceTypeItunes:
            return @"Open with iTunes";
        case MGMAlbumServiceTypeDeezer:
            return @"Open with Deezer";
        default:
            return nil;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keyValuePairs.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        cell.textLabel.font = [UIFont fontWithName:DEFAULT_FONT_MEDIUM size:self.ipad ? 22.0 : 14.0];
    }

    MGMKeyValuePair* pair = [self.keyValuePairs objectAtIndex:indexPath.row];
    cell.textLabel.text = pair.displayString;
    cell.imageView.image = [self imageForServiceType:pair.serviceType];

    return cell;
}

- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeLastFm:
            return [UIImage imageNamed:@"lastfm.png"];
        case MGMAlbumServiceTypeSpotify:
            return [UIImage imageNamed:@"spotify.png"];
        case MGMAlbumServiceTypeWikipedia:
            return [UIImage imageNamed:@"wikipedia.png"];
        case MGMAlbumServiceTypeYouTube:
            return [UIImage imageNamed:@"youtube.png"];
        case MGMAlbumServiceTypeItunes:
            return [UIImage imageNamed:@"itunes.png"];
        case MGMAlbumServiceTypeDeezer:
            return [UIImage imageNamed:@"deezer.png"];
        default:
            return nil;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.ipad ? 42.0 : 28.0;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMKeyValuePair* pair = [self.keyValuePairs objectAtIndex:indexPath.row];
    MGMAlbum* album = [self.core.daoFactory.coreDataDao threadVersion:self.albumMoid];
    [self.ui.albumPlayer playAlbum:album onService:pair.serviceType completion:^(NSError* error)
    {
        if (error)
        {
            [self showError:error];
        }
    }];
    [self cancelButtonPressed:nil];
}

#pragma mark -
#pragma mark MGMAlbumDetailViewDelegate

- (void) cancelButtonPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
