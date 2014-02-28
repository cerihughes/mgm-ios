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

@interface MGMAbstractEventViewController () <MGMAbstractEventViewDelegate>

@property BOOL renderedFirstEvent;

@end

@implementation MGMAbstractEventViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.renderedFirstEvent == NO)
    {
        MGMAbstractEventView* eventView = (MGMAbstractEventView*)self.view;
        [eventView.classicAlbumView setActivityInProgress:YES];
        [eventView.newlyReleasedAlbumView setActivityInProgress:YES];
        self.renderedFirstEvent = YES;
    }
}

- (void) displayEvent:(MGMEvent*)event playlist:(MGMPlaylist*)playlist
{
    _event = event;
    _playlist = playlist;

    MGMAbstractEventView* eventView = (MGMAbstractEventView*)self.view;

    NSUInteger rank = 1;
    if (playlist)
    {
        for (MGMPlaylistItem* item in playlist.playlistItems)
        {
            MGMAlbumView* albumView = [eventView.playlistView albumViewForRank:rank++];
            NSError* error = nil;
            [self.ui.viewUtilities displayPlaylistItem:item inAlbumView:albumView error:&error];
            if (error)
            {
                [self.ui logError:error];
            }
        }
    }
    eventView.playlistView.hidden = (playlist == nil);
    eventView.playlistLabel.hidden = (playlist == nil);

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

    [eventView setNeedsLayout];
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
        [self.playlistSelectionDelegate playlistSelected:self.playlist];
    }
}

@end
