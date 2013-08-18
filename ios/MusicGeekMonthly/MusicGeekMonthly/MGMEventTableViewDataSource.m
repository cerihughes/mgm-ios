//
//  MGMEventTableViewDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventTableViewDataSource.h"

#import "MGMEvent.h"
#import "MGMImageHelper.h"

@implementation MGMEventTableViewDataSource

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    MGMEvent* event = [super.fetchedResultsController objectAtIndexPath:indexPath];

    MGMAlbum* classicAlbum = event.classicAlbum;
    if ([classicAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
        [self.lastFmDao updateAlbumInfo:classicAlbum completion:^(MGMAlbum* updatedAlbum, NSError* updateError)
        {
            if (updateError == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    // ... but update the UI in the main thread...
                    [self addAlbumImage:updatedAlbum toCell:cell];
                });
            }
         }];
    }
    else
    {
        [self addAlbumImage:classicAlbum toCell:cell];
    }
    return cell;
}

- (void) addAlbumImage:(MGMAlbum*)album toCell:(UITableViewCell*)cell
{
    NSString* albumArtUri = [album bestTableImageUrl];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage* image, NSError* error)
        {
            if (error == nil)
            {
                cell.imageView.image = image;
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"album1.png"];
            }
        }];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"album1.png"];
    }
}


@end
