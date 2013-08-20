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
    CGFloat image1X = 20;

    CGSize parentSize = self.frame.size;
    CGFloat parentWidth = parentSize.width;
    CGFloat parentHeight = parentSize.height;

    CGFloat imageHeight = parentHeight - 4;

    CGRect image1Frame = CGRectMake(image1X, 2, imageHeight, imageHeight);
    CGRect image2Frame = CGRectOffset(image1Frame, imageHeight + 4, 0);
    CGRect labelFrame = CGRectOffset(image2Frame, imageHeight + 4, 0);

    labelFrame.size.width = parentWidth - (image1X + (2 * imageHeight + 4));

    self.classicAlbumImageView.frame = image1Frame;
    self.newlyReleasedAlbumImageView.frame = image2Frame;
    self.eventTextLabel.frame = labelFrame;
}

@end
