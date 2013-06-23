//
//  MGMAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 16/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumView.h"

#define LISTENERS_FORMAT @"%d geeks listening this week"

@interface MGMAlbumView ()

@property (strong) UIButton* imageButton;
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
    label.shadowOffset = CGSizeMake(2, 2);

    return label;
}

- (void) commonInit
{
    CGSize size = self.frame.size;
    CGFloat width = size.width - 4;
    CGFloat height = size.height - 4;

    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.frame = CGRectMake(2, 2, width, height);
    self.imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.imageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.imageButton.userInteractionEnabled = YES;
    [self.imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.imageButton];

    CGFloat fontSize = height / 4 / 1.3;
    self.rankLabel = [self createLabelWithRect:CGRectMake(2, 2, width / 4, height / 4) fontName:DEFAULT_FONT_BOLD fontSize:fontSize];
    self.rankLabel.alpha = 0.75;
    [self.imageButton addSubview:self.rankLabel];

    CGFloat textParentViewWidth = width - 4;
    CGFloat textParentViewHeight = height / 4;
    CGFloat y = height - textParentViewHeight - 2;
    UIView* textParentView = [[UIView alloc] initWithFrame:CGRectMake(2, y, textParentViewWidth, textParentViewHeight)];
    textParentView.autoresizesSubviews = YES;
    textParentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    textParentView.backgroundColor = [UIColor clearColor];
    [self.imageButton addSubview:textParentView];

    CGFloat textWidth = textParentViewWidth - 4;
    CGFloat textHeight = textParentViewHeight / 3;
    fontSize = textHeight / 1.3;
    self.artistLabel = [self createLabelWithRect:CGRectMake(2, 0, textWidth, textHeight) fontName:DEFAULT_FONT_BOLD fontSize:fontSize];
    [textParentView addSubview:self.artistLabel];

    self.albumLabel = [self createLabelWithRect:CGRectMake(2, textHeight, textWidth, textHeight) fontName:DEFAULT_FONT_MEDIUM fontSize:fontSize];
    [textParentView addSubview:self.albumLabel];

    self.listenersLabel = [self createLabelWithRect:CGRectMake(2, textHeight * 2, textWidth, textHeight) fontName:DEFAULT_FONT_ITALIC fontSize:fontSize];
    [textParentView addSubview:self.listenersLabel];
}

- (UIImage*) albumImage
{
    return self.imageButton.imageView.image;
}

- (void) setAlbumImage:(UIImage *)albumImage
{
    [self.imageButton setImage:albumImage forState:UIControlStateNormal];
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

- (void) buttonPressed:(id)receiver
{
    [self.delegate albumPressed:self];
}

@end
