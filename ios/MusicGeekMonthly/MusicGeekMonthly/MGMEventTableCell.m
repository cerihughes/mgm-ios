//
//  MGMEventTableCell.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventTableCell.h"

@implementation MGMEventTableCell

- (void) layoutSubviews
{
    CGFloat image1X = self.classicAlbumImageView.frame.origin.x;
    CGFloat imageHeight = self.frame.size.height;

    CGRect image1Frame = CGRectMake(image1X, 0, imageHeight, imageHeight);
    CGRect image2Frame = CGRectOffset(image1Frame, imageHeight + 4, 0);

    self.classicAlbumImageView.frame = image1Frame;
    self.newlyReleasedAlbumImageView.frame = image2Frame;
}

@end
