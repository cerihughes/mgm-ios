//
//  MGMAbstractEventViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 06/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventViewController.h"

#import "MGMAbstractEventView.h"
#import "MGMAlbumViewUtilities.h"
#import "MGMPlaylistDto.h"
#import "MGMPlaylistItemDto.h"

@interface MGMAbstractEventViewController () <MGMAbstractEventViewDelegate>

@end

@implementation MGMAbstractEventViewController

- (void) displayEvent:(MGMEvent*)event playlist:(MGMPlaylistDto*)playlist
{
    _event = event;
    _playlist = playlist;

    MGMAbstractEventView* eventView = (MGMAbstractEventView*)self.view;

    NSUInteger rank = 1;
    if (playlist)
    {
        for (MGMPlaylistItemDto* item in playlist.playlistItems)
        {
            MGMAlbumView* albumView = [eventView.playlistView albumViewForRank:rank++];
            NSError* error = nil;
            [self.ui.viewUtilities displayPlaylistItemDto:item inAlbumView:albumView error:&error];
            if (error)
            {
                [self.ui logError:error];
            }
        }
    }

    NSError* error1 = nil;
    [self.ui.viewUtilities displayAlbum:event.classicAlbum inAlbumView:eventView.classicAlbumView error:&error1];
    if (error1)
    {
        [self logError:error1];
    }
    
    NSError* error2 = nil;
    [self.ui.viewUtilities displayAlbum:event.newlyReleasedAlbum inAlbumView:eventView.newlyReleasedAlbumView error:&error2];
    if (error2)
    {
        [self logError:error2];
    }
}

#pragma mark -
#pragma mark MGMAbstractEventViewDelegate

- (void) classicAlbumPressed
{
    [self.albumSelectionDelegate albumSelected:self.event.classicAlbum];
}

- (void) classicAlbumDetailPressed
{
    [self.albumSelectionDelegate detailSelected:self.event.classicAlbum sender:self];
}

- (void) newlyReleasedAlbumPressed
{
    [self.albumSelectionDelegate albumSelected:self.event.newlyReleasedAlbum];
}

- (void) newlyReleasedAlbumDetailPressed
{
    [self.albumSelectionDelegate detailSelected:self.event.newlyReleasedAlbum sender:self];
}

- (void) playlistPressed
{
    [self.playlistSelectionDelegate playlistSelected:self.playlist];
}

@end
