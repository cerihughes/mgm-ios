//
//  MGMAlbumScoresViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoresViewController.h"

#import "MGMAlbumScoresView.h"
#import "MGMAlbumViewUtilities.h"
#import "MGMCoreDataTableViewDataSource.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"

@interface MGMAlbumScoresViewController () <MGMAlbumGridViewDelegate, MGMAlbumScoresViewDelegate>

@property (strong) NSArray* albumMoids;

@end

@implementation MGMAlbumScoresViewController

- (void) loadView
{
    MGMAlbumScoresView* scoresView = [[MGMAlbumScoresView alloc] initWithFrame:[self fullscreenRect]];
    scoresView.albumGridView.delegate = self;
    scoresView.delegate = self;

    self.view = scoresView;
}

- (void) viewDidLoad
{
    MGMAlbumScoresView* scoresView = (MGMAlbumScoresView*)self.view;

    // Setup 25 albums so we can put them into "activity in progress" mode...
    NSUInteger albumCount = 25;
    [scoresView.albumGridView setAlbumCount:albumCount detailViewShowing:YES];
    NSUInteger rowCount = self.ipad ? 4 : 2;
    NSUInteger columnCount = (albumCount + 3) / rowCount;
    CGFloat albumSize = scoresView.albumGridView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [scoresView.albumGridView setAlbumFrame:frame forRank:i + 1];
    }

    [scoresView setSelection:MGMAlbumScoresViewSelectionClassicAlbums];
}

- (void) loadAlbumsForChoice:(NSInteger)choice
{
    MGMAlbumScoresView* scoresView = (MGMAlbumScoresView*)self.view;

    dispatch_async(dispatch_get_main_queue(), ^
    {
        [scoresView.albumGridView setActivityInProgressForAllRanks:YES];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        MGMDaoData* data = [self dataForChoice:choice];
        NSArray* albumMoids = data.data;
        NSError* fetchError = data.error;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Resize the album view for new data...
            NSUInteger albumCount = albumMoids.count;
            [scoresView.albumGridView setAlbumCount:albumCount detailViewShowing:YES];
            NSUInteger rowCount = self.ipad ? 4 : 2;
            NSUInteger columnCount = ((albumCount + 3) / rowCount) + 1;
            CGFloat albumSize = scoresView.albumGridView.frame.size.width / rowCount;
            NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

            for (NSUInteger i = 0; i < albumCount; i++)
            {
                NSValue* value = [gridData objectAtIndex:i];
                CGRect frame = [value CGRectValue];
                [scoresView.albumGridView setAlbumFrame:frame forRank:i + 1];
            }

            [scoresView.albumGridView setActivityInProgressForAllRanks:YES];

            if (fetchError && albumMoids)
            {
                [self logError:fetchError];
            }

            if (albumMoids)
            {
                self.albumMoids = albumMoids;
                [self reloadAlbums];
            }
            else
            {
                [self showError:fetchError];
            }
        });
    });
}

- (MGMDaoData*) dataForChoice:(NSInteger)choice
{
    MGMDaoData* data = nil;
    switch (choice) {
        case 0:
            data = [self.core.dao fetchAllClassicAlbums];
            break;
        case 1:
            data = [self.core.dao fetchAllNewlyReleasedAlbums];
            break;
        case 2:
            data = [self.core.dao fetchAllEventAlbums];
        default:
            break;
    }

    NSArray* albums = data.data;
    NSMutableArray* albumMoids = [NSMutableArray arrayWithCapacity:albums.count];
    for (MGMAlbum* album in albums)
    {
        [albumMoids addObject:album.objectID];
    }
    data.data = [albumMoids copy];
    return data;
}

- (void) reloadAlbums
{
    NSUInteger position = 1;
    for (NSManagedObjectID* albumMoid in self.albumMoids)
    {
        MGMAlbum* album = [self.core.coreDataAccess threadVersion:albumMoid];
        NSError* refreshError = nil;
        [self.core.albumRenderService refreshAlbumImages:album error:&refreshError];

        if (refreshError)
        {
            [self logError:refreshError];
        }

        [self renderAlbum:album atPostion:position];

        position++;
    }
}

- (void) renderAlbum:(MGMAlbum*)album atPostion:(NSUInteger)position
{
    MGMAlbumScoresView* scoresView = (MGMAlbumScoresView*)self.view;
    MGMAlbumView* albumView = [scoresView.albumGridView albumViewForRank:position];
    NSError* error = nil;
    [self.ui.viewUtilities displayAlbum:album inAlbumView:albumView rank:position error:&error];
    if (error)
    {
        [self.ui logError:error];
    }
}

#pragma mark -
#pragma mark MGMAlbumGridViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    NSManagedObjectID* albumMoid = [self.albumMoids objectAtIndex:rank - 1];
    MGMAlbum* album = [self.core.coreDataAccess threadVersion:albumMoid];
    [self.albumSelectionDelegate albumSelected:album];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    NSManagedObjectID* albumMoid = [self.albumMoids objectAtIndex:rank - 1];
    MGMAlbum* album = [self.core.coreDataAccess threadVersion:albumMoid];
    [self.albumSelectionDelegate detailSelected:album sender:self];
}

#pragma mark -
#pragma mark MGMAlbumScoresViewDelegate

- (void) selectionChanged:(MGMAlbumScoresViewSelection)selection
{
    [self loadAlbumsForChoice:selection];
}

@end
