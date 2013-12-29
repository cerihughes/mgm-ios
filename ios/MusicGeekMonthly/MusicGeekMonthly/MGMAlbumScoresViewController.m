//
//  MGMAlbumScoresViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoresViewController.h"

#import "MGMAlbumScoresView.h"
#import "MGMCoreDataTableViewDataSource.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"

@interface MGMAlbumScoresViewController () <MGMWeeklyChartAlbumsViewDelegate, MGMAlbumScoresViewDelegate>

@property (strong) NSArray* albumMoids;

@end

@implementation MGMAlbumScoresViewController

- (void) loadView
{
    MGMAlbumScoresView* scoresView = [[MGMAlbumScoresView alloc] initWithFrame:[self fullscreenRect]];
    scoresView.albumsView.delegate = self;
    scoresView.delegate = self;

    self.view = scoresView;
}

- (void) viewDidLoad
{
    MGMAlbumScoresView* scoresView = (MGMAlbumScoresView*)self.view;

    // Setup 25 albums so we can put them into "activity in progress" mode...
    NSUInteger albumCount = 25;
    NSUInteger rowCount = self.ipad ? 4 : 2;
    NSUInteger columnCount = (albumCount + 3) / rowCount;
    CGFloat albumSize = scoresView.albumsView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [scoresView.albumsView setupAlbumFrame:frame forRank:i + 1];
    }

    [scoresView setSelection:MGMAlbumScoresViewSelectionClassicAlbums];
}

- (void) loadAlbumsForChoice:(NSInteger)choice
{
    MGMAlbumScoresView* scoresView = (MGMAlbumScoresView*)self.view;

    dispatch_async(dispatch_get_main_queue(), ^
    {
        [scoresView.albumsView setActivityInProgressForAllRanks:YES];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [self dataForChoice:choice completion:^(NSArray* albumMoids, NSError* fetchError)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // Resize the album view for new data...
                [scoresView.albumsView clearAllAlbumFrames];

                BOOL iPad = self.view.frame.size.width > 320;
                NSUInteger albumCount = albumMoids.count;
                NSUInteger rowCount = iPad ? 4 : 2;
                NSUInteger columnCount = ((albumCount + 3) / rowCount) + 1;
                CGFloat albumSize = scoresView.albumsView.frame.size.width / rowCount;
                NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

                for (NSUInteger i = 0; i < albumCount; i++)
                {
                    NSValue* value = [gridData objectAtIndex:i];
                    CGRect frame = [value CGRectValue];
                    [scoresView.albumsView setupAlbumFrame:frame forRank:i + 1];
                }

                [scoresView.albumsView setActivityInProgressForAllRanks:YES];

            });

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
        }];
    });
}

- (void) dataForChoice:(NSInteger)choice completion:(FETCH_MANY_COMPLETION)completion
{

    FETCH_MANY_COMPLETION convertToMoids = ^(NSArray* albums, NSError* error)
    {
        NSMutableArray* albumMoids = [NSMutableArray arrayWithCapacity:albums.count];
        for (MGMAlbum* album in albums)
        {
            [albumMoids addObject:album.objectID];
        }
        completion(albumMoids, error);
    };

    switch (choice) {
        case 0:
            [self.core.daoFactory.eventsDao fetchAllClassicAlbums:convertToMoids];
            break;
        case 1:
            [self.core.daoFactory.eventsDao fetchAllNewlyReleasedAlbums:convertToMoids];
            break;
        case 2:
            [self.core.daoFactory.eventsDao fetchAllEventAlbums:convertToMoids];
        default:
            break;
    }
}

- (void) reloadAlbums
{
    NSUInteger position = 1;
    for (NSManagedObjectID* albumMoid in self.albumMoids)
    {
        MGMAlbum* album = [self.core.daoFactory.coreDataDao threadVersion:albumMoid];
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album completion:^(MGMAlbum* updatedAlbum, NSError* fetchError)
            {
                if (fetchError && updatedAlbum)
                {
                    [self logError:fetchError];
                }

                if (updatedAlbum)
                {
                    [self renderAlbum:album atPostion:position];
                }
                else
                {
                    [self showError:fetchError];
                }
            }];
        }
        else
        {
            [self renderAlbum:album atPostion:position];
        }
        position++;
    }
}

- (void) renderAlbum:(MGMAlbum*)album atPostion:(NSUInteger)position
{
    MGMAlbumScoresView* scoresView = (MGMAlbumScoresView*)self.view;

    NSArray* albumArtUrls = [album bestAlbumImageUrls];
    if (albumArtUrls.count > 0)
    {
        [MGMImageHelper asyncImageFromUrls:albumArtUrls completion:^(UIImage* image, NSError* error)
        {
            if (error)
            {
                [self logError:error];
            }

            if (image == nil)
            {
                image = [self defaultImageForRank:position];
            }

            dispatch_async(dispatch_get_main_queue(), ^
            {
                [scoresView.albumsView setActivityInProgress:NO forRank:position];
                [scoresView.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:position listeners:0 score:[album.score floatValue]];
            });
        }];
    }
    else
    {
        UIImage* image = [self defaultImageForRank:position];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [scoresView.albumsView setActivityInProgress:NO forRank:position];
            [scoresView.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:position listeners:0 score:[album.score floatValue]];
        });
    }
}

- (UIImage*) defaultImageForRank:(NSUInteger)rank
{
    NSUInteger albumType = (rank % 3) + 1;
    NSString* imageName = [NSString stringWithFormat:@"album%d.png", albumType];
    return [UIImage imageNamed:imageName];
}

#pragma mark -
#pragma mark MGMWeeklyChartAlbumsViewDelegate

- (void) albumPressedWithRank:(NSUInteger)rank
{
    NSManagedObjectID* albumMoid = [self.albumMoids objectAtIndex:rank - 1];
    MGMAlbum* album = [self.core.daoFactory.coreDataDao threadVersion:albumMoid];
    [self.albumSelectionDelegate albumSelected:album];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    NSManagedObjectID* albumMoid = [self.albumMoids objectAtIndex:rank - 1];
    MGMAlbum* album = [self.core.daoFactory.coreDataDao threadVersion:albumMoid];
    [self.albumSelectionDelegate detailSelected:album sender:self];
}

#pragma mark -
#pragma mark MGMAlbumScoresViewDelegate

- (void) selectionChanged:(MGMAlbumScoresViewSelection)selection
{
    [self loadAlbumsForChoice:selection];
}

@end
