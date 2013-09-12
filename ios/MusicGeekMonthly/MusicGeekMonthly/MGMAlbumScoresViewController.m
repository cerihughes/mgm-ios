//
//  MGMAlbumScoresViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoresViewController.h"

#import "MGMCoreDataTableViewDataSource.h"
#import "MGMGridManager.h"
#import "MGMImageHelper.h"
#import "MGMWeeklyChartAlbumsView.h"

@interface MGMAlbumScoresViewController () <MGMWeeklyChartAlbumsViewDelegate, UITableViewDelegate>

@property (strong) IBOutlet MGMWeeklyChartAlbumsView* albumsView;
@property (strong) NSArray* albums;

@end

@implementation MGMAlbumScoresViewController

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
    }
    return self;
}

- (IBAction) segmentSwitched:(UISegmentedControl*)sender
{
    [self loadAlbumsForChoice:sender.selectedSegmentIndex];
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.albumsView.delegate = self;

    // Setup 25 albums so we can put them into "activity in progress" mode...
    BOOL iPad = self.view.frame.size.width > 320;
    NSUInteger albumCount = 25;
    NSUInteger rowCount = iPad ? 4 : 2;
    NSUInteger columnCount = (albumCount + 3) / rowCount;
    CGFloat albumSize = self.albumsView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [self.albumsView setupAlbumFrame:frame forRank:i + 1];
    }

    [self segmentSwitched:0];
}

- (void) loadAlbumsForChoice:(NSInteger)choice
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.albumsView setActivityInProgressForAllRanks:YES];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [self dataForChoice:choice completion:^(NSArray* albums, NSError* fetchError)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // Resize the album view for new data...
                [self.albumsView clearAllAlbumFrames];

                BOOL iPad = self.view.frame.size.width > 320;
                NSUInteger albumCount = albums.count;
                NSUInteger rowCount = iPad ? 4 : 2;
                NSUInteger columnCount = (albumCount + 3) / rowCount;
                CGFloat albumSize = self.albumsView.frame.size.width / rowCount;
                NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:columnCount size:albumSize count:albumCount];

                for (NSUInteger i = 0; i < albumCount; i++)
                {
                    NSValue* value = [gridData objectAtIndex:i];
                    CGRect frame = [value CGRectValue];
                    [self.albumsView setupAlbumFrame:frame forRank:i + 1];
                }

                [self.albumsView setActivityInProgressForAllRanks:YES];

            });

            if (fetchError && albums)
            {
                [self logError:fetchError];
            }

            if (albums)
            {
                self.albums = albums;
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
    switch (choice) {
        case 0:
            [self.core.daoFactory.eventsDao fetchAllClassicAlbums:completion];
            break;
        case 1:
            [self.core.daoFactory.eventsDao fetchAllNewlyReleasedAlbums:completion];
            break;
        case 2:
            [self.core.daoFactory.eventsDao fetchAllEventAlbums:completion];
        default:
            break;
    }
}

- (void) reloadAlbums
{
    NSUInteger position = 1;
    for (MGMAlbum* album in self.albums)
    {
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
    NSString* albumArtUri = [album bestAlbumImageUrl];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage* image, NSError* error)
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
                [self.albumsView setActivityInProgress:NO forRank:position];
                [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:position listeners:0 score:[album.score floatValue]];
            });
        }];
    }
    else
    {
        UIImage* image = [self defaultImageForRank:position];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.albumsView setActivityInProgress:NO forRank:position];
            [self.albumsView setAlbumImage:image artistName:album.artistName albumName:album.albumName rank:position listeners:0 score:[album.score floatValue]];
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
    MGMAlbum* album = [self.albums objectAtIndex:rank - 1];
    [self.albumSelectionDelegate albumSelected:album];
}

- (void) detailPressedWithRank:(NSUInteger)rank
{
    MGMAlbum* album = [self.albums objectAtIndex:rank - 1];
    [self.albumSelectionDelegate detailSelected:album sender:self];
}

@end
