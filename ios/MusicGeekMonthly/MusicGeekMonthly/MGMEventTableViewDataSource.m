//
//  MGMEventTableViewDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventTableViewDataSource.h"

#import "MGMEvent.h"
#import "MGMEventTableCell.h"
#import "MGMImageHelper.h"

@implementation MGMEventTableViewDataSource

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMEventTableCell* cell = (MGMEventTableCell*) [tableView dequeueReusableCellWithIdentifier:self.cellId];
    if (cell == nil)
    {
        cell = [[MGMEventTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellId];
    }

    MGMEvent* event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.eventTextLabel.text = event.groupValue;

    MGMAlbum* classicAlbum = event.classicAlbum;
    if ([classicAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
//        [self.lastFmDao updateAlbumInfo:classicAlbum completion:^(MGMAlbum* updatedAlbum, NSError* updateError)
//        {
//            if (updateError == nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^
//                {
//                    // ... but update the UI in the main thread...
//                    [self addAlbumImage:updatedAlbum toCell:cell.classicAlbumImageView];
//                });
//            }
//         }];
    }
    else
    {
        [self addAlbumImage:classicAlbum toCell:cell.classicAlbumImageView];
    }

    MGMAlbum* newlyReleaseAlbum = event.newlyReleasedAlbum;
    if ([newlyReleaseAlbum searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
    {
//        [self.lastFmDao updateAlbumInfo:newlyReleaseAlbum completion:^(MGMAlbum* updatedAlbum, NSError* updateError)
//        {
//            if (updateError == nil)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^
//                {
//                    // ... but update the UI in the main thread...
//                    [self addAlbumImage:updatedAlbum toCell:cell.newlyReleasedAlbumImageView];
//                });
//            }
//        }];
    }
    else
    {
        [self addAlbumImage:newlyReleaseAlbum toCell:cell.newlyReleasedAlbumImageView];
    }

    return cell;
}

- (void) addAlbumImage:(MGMAlbum*)album toCell:(UIImageView*)imageView
{
    NSString* albumArtUri = [album bestTableImageUrl];
    if (albumArtUri)
    {
        [MGMImageHelper asyncImageFromUrl:albumArtUri completion:^(UIImage* image, NSError* error)
        {
            if (error == nil)
            {
                imageView.image = image;
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"album1.png"];
            }
        }];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"album1.png"];
    }
}


@end
