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

    cell.classicAlbumImageView.image = nil;
    cell.newlyReleasedAlbumImageView.image = nil;

    MGMEvent* event = [self objectAtIndexPath:indexPath];
    cell.eventTextLabel.text = event.groupValue;

    [cell.classicAlbumActivityView startAnimating];
    [self addAlbumImage:event.classicAlbum.objectID toImageView:cell.classicAlbumImageView withActivityView:cell.classicAlbumActivityView inCell:cell];

    [cell.newlyReleasedAlbumActivityView startAnimating];
    [self addAlbumImage:event.newlyReleasedAlbum.objectID toImageView:cell.newlyReleasedAlbumImageView withActivityView:cell.newlyReleasedAlbumActivityView inCell:cell];

    return cell;
}

- (void) addAlbumImage:(NSManagedObjectID*)albumMoid toImageView:(UIImageView*)imageView withActivityView:(UIActivityIndicatorView*)activityIndicatorView inCell:(MGMEventTableCell*)cell
{
    MGMAlbum* album = [self.coreDataAccess mainThreadVersion:albumMoid];
    [self.albumRenderService refreshAlbum:album completion:^(NSError* refreshError) {
        if (refreshError == nil)
        {
            MGMAlbumImageSize preferredSize = preferredImageSize(cell.classicAlbumImageView.frame.size, self.screenScale);
            NSArray* albumArtUrls = [album bestImageUrlsWithPreferredSize:preferredSize];
            if (albumArtUrls.count > 0)
            {
                [self.imageHelper imageFromUrls:albumArtUrls completion:^(UIImage* image, NSError* error) {
                    [activityIndicatorView stopAnimating];
                    if (image && error == nil)
                    {
                        imageView.image = image;
                    }
                    else
                    {
                        imageView.image = [self.imageHelper nextDefaultImage];
                    }
                    [cell setNeedsDisplay];
                }];
                return;
            }
        }
        [activityIndicatorView stopAnimating];
        imageView.image = [self.imageHelper nextDefaultImage];
        [cell setNeedsDisplay];
    }];
}

@end
