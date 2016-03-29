//
//  MGMAbstractEventViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventViewController.h"

#import "MGMAlbumGridView.h"
#import "MGMAlbumView.h"
#import "MGMEvent.h"
#import "MGMPlaylist.h"
#import "MGMPlaylistItem.h"
#import "MGMUI.h"

@interface MGMAbstractEventViewController () <MGMAbstractEventViewDelegate>

@property BOOL renderedFirstEvent;

@end

@implementation MGMAbstractEventViewController

@dynamic view;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.renderedFirstEvent == NO)
    {
        [self.view.classicAlbumView setActivityInProgress:YES];
        [self.view.newlyReleasedAlbumView setActivityInProgress:YES];
        self.renderedFirstEvent = YES;
    }
}

- (void) displayEvent:(MGMEvent*)event playlist:(MGMPlaylist*)playlist
{
    _event = event;
    _playlist = playlist;

    BOOL hasPlaylist = YES;
    if (playlist)
    {
        NSUInteger rank = 1;
        for (MGMPlaylistItem* item in playlist.playlistItems)
        {
            MGMAlbumView* albumView = [self.view.playlistView albumViewForRank:rank++];
            [self displayPlaylistItem:item inAlbumView:albumView completion:^(NSError* error) {
                [self.ui logError:error];
            }];
        }
    }
    else if (event.playlistId)
    {
        // There's been an error loading the playlist.
        NSUInteger albumCount = self.view.playlistView.albumCount;
        for (NSUInteger i = 0; i < albumCount; i++)
        {
            NSUInteger rank = i + 1;
            MGMAlbumView* albumView = [self.view.playlistView albumViewForRank:rank++];
            [self displayPlaylistItem:nil inAlbumView:albumView completion:^(NSError* error) {
                [self.ui logError:error];
            }];
        }
    }
    else
    {
        hasPlaylist = NO;
    }


    self.view.playlistView.hidden = (hasPlaylist == NO);
    self.view.playlistLabel.hidden = (hasPlaylist == NO);

    [self displayAlbum:event.classicAlbum inAlbumView:self.view.classicAlbumView completion:^(NSError* error) {
        [self logError:error];
    }];

    [self displayAlbum:event.newlyReleasedAlbum inAlbumView:self.view.newlyReleasedAlbumView completion:^(NSError* error) {
        [self logError:error];
    }];

    [self.view setNeedsLayout];
}

- (void) displayPlaylistItem:(MGMPlaylistItem*)playlistItem inAlbumView:(MGMAlbumView*)albumView completion:(ALBUM_DISPLAY_COMPLETION)completion
{
    albumView.activityInProgress = YES;
    albumView.rank = 0;

    MGMAlbumImageSize preferredSize = preferredImageSize(albumView.frame.size, self.screenScale);
    NSArray* albumArtUrls = [playlistItem bestImageUrlsWithPreferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView completion:completion];
}

#pragma mark -
#pragma mark MGMAbstractEventViewDelegate

- (void) classicAlbumPressed
{
    if (self.event.classicAlbum)
    {
        [self.albumSelectionDelegate albumSelected:self.event.classicAlbum];
    }
}

- (void) classicAlbumDetailPressed
{
    if (self.event.classicAlbum)
    {
        [self.albumSelectionDelegate detailSelected:self.event.classicAlbum sender:self];
    }
}

- (void) newlyReleasedAlbumPressed
{
    if (self.event.newlyReleasedAlbum)
    {
        [self.albumSelectionDelegate albumSelected:self.event.newlyReleasedAlbum];
    }
}

- (void) newlyReleasedAlbumDetailPressed
{
    if (self.event.newlyReleasedAlbum)
    {
        [self.albumSelectionDelegate detailSelected:self.event.newlyReleasedAlbum sender:self];
    }
}

- (void) playlistPressed
{
    if (self.playlist)
    {
        [self.playlistSelectionDelegate playlistSelected:self.playlist.playlistId];
    }
    else if (self.event.playlistId)
    {
        [self.playlistSelectionDelegate playlistSelected:self.event.playlistId];
    }
}

@end
