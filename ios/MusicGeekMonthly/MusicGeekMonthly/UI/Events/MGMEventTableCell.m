//
//  MGMEventTableCell.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventTableCell.h"

#import "MGMView.h"

@implementation MGMEventTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    self.classicAlbumImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.newlyReleasedAlbumImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.classicAlbumActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.newlyReleasedAlbumActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.eventTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.eventTextLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:17.0];

    [self addSubview:self.classicAlbumImageView];
    [self addSubview:self.newlyReleasedAlbumImageView];
    [self addSubview:self.classicAlbumActivityView];
    [self addSubview:self.newlyReleasedAlbumActivityView];
    [self addSubview:self.eventTextLabel];
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

    self.classicAlbumImageView.frame = image1Frame;
    self.classicAlbumActivityView.frame = image1Frame;
    self.newlyReleasedAlbumImageView.frame = image2Frame;
    self.newlyReleasedAlbumActivityView.frame = image2Frame;
    self.eventTextLabel.frame = labelFrame;
}

@end
