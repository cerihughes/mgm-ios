//
//  MGMAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 16/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumView.h"

#define LISTENERS_FORMAT @"%d geeks listening this week"

@interface MGMAlbumView()

@property (strong) UIImageView* imageView;
@property (strong) UILabel* artistLabel;
@property (strong) UILabel* albumLabel;
@property (strong) UILabel* rankLabel;
@property (strong) UILabel* listenersLabel;

@end

@implementation MGMAlbumView
{
    NSUInteger _listeners;
}

- (UILabel*) createLabelWithRect:(CGRect)rect fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
{
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    return label;
}

- (void) commonInit
{
    CGSize size = self.frame.size;
    CGFloat width = size.width - 4;
    CGFloat height = size.height - 4;

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, width, height)];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.imageView];

    self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, width / 3, height / 3)];
    self.rankLabel.backgroundColor = [UIColor clearColor];
    self.rankLabel.textColor = [UIColor whiteColor];
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    self.rankLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:32];
    self.rankLabel.alpha = 0.5;
    [self.imageView addSubview:self.rankLabel];

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
    CGFloat textHeight = textParentViewHeight / 3;
    self.artistLabel = [self createLabelWithRect:CGRectMake(2, 0, textWidth, textHeight) fontName:DEFAULT_FONT_BOLD fontSize:10];
    [textParentView addSubview:self.artistLabel];

    self.albumLabel = [self createLabelWithRect:CGRectMake(2, textHeight, textWidth, textHeight) fontName:DEFAULT_FONT_MEDIUM fontSize:10];
    [textParentView addSubview:self.albumLabel];

    self.listenersLabel = [self createLabelWithRect:CGRectMake(2, textHeight * 2, textWidth, textHeight) fontName:DEFAULT_FONT_ITALIC fontSize:10];
    [textParentView addSubview:self.listenersLabel];
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

- (NSUInteger) rank
{
    return self.rankLabel.text.intValue;
}

- (void) setRank:(NSUInteger)rank
{
    self.rankLabel.text = [NSString stringWithFormat:@"%d", rank];
}

- (NSUInteger) listeners
{
    return _listeners;
}

- (void) setListeners:(NSUInteger)listeners
{
    self.listenersLabel.text = [NSString stringWithFormat:LISTENERS_FORMAT, listeners];
    _listeners = listeners;
}


@end
