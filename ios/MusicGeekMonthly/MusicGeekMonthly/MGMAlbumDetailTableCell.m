//
//  MGMAlbumDetailTableCell.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailTableCell.h"

@implementation MGMAlbumDetailTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
    }
    return self;
}

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
}

@end
