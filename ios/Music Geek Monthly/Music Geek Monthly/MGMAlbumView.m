//
//  MGMAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 16/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumView.h"

@interface MGMAlbumView()

@property (strong) UIImageView* imageView;
@property (strong) UILabel* artistLabel;
@property (strong) UILabel* albumLabel;
@property (strong) UILabel* rankLabel;

@end

@implementation MGMAlbumView

- (void) commonInit
{
    CGSize size = self.frame.size;
    CGFloat width = size.width - 4;
    CGFloat height = size.height - 4;

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, width, height)];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.imageView];

    CGFloat textParentViewWidth = width - 4;
    CGFloat textParentViewHeight = height / 4;
    CGFloat y = height - textParentViewHeight - 2;
    UIView* textParentView = [[UIView alloc] initWithFrame:CGRectMake(2, y, textParentViewWidth, textParentViewHeight)];
    textParentView.autoresizesSubviews = YES;
    textParentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    textParentView.backgroundColor = [UIColor clearColor];
//    textParentView.alpha = 0.5;
    [self.imageView addSubview:textParentView];

    CGFloat textWidth = textParentViewWidth - 4;
    CGFloat textHeight = textParentViewHeight / 2;
    self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, textWidth, textHeight)];
    self.artistLabel.textAlignment = NSTextAlignmentCenter;
    self.artistLabel.backgroundColor = [UIColor clearColor];
    self.artistLabel.textColor = [UIColor whiteColor];
    self.artistLabel.shadowColor = [UIColor blackColor];
    self.artistLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:10];
    [textParentView addSubview:self.artistLabel];

    self.albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 4 + textHeight, textWidth, textHeight)];
    self.albumLabel.textAlignment = NSTextAlignmentCenter;
    self.albumLabel.backgroundColor = [UIColor clearColor];
    self.albumLabel.textColor = [UIColor whiteColor];
    self.albumLabel.shadowColor = [UIColor blackColor];
    self.albumLabel.font = [UIFont fontWithName:DEFAULT_FONT_MEDIUM size:10];
    [textParentView addSubview:self.albumLabel];
}

- (UIImage*) albumImage
{
    return self.imageView.image;
}

- (void) setAlbumImage:(UIImage *)albumImage
{
    self.imageView.image = albumImage;
}

- (NSString*) artistName
{
    return self.artistLabel.text;
}

- (void) setArtistName:(NSString *)artistName
{
    self.artistLabel.text = artistName;
}

- (NSString*) albumName
{
    return self.albumLabel.text;
}

- (void) setAlbumName:(NSString *)albumName
{
    self.albumLabel.text = albumName;
}

@end
