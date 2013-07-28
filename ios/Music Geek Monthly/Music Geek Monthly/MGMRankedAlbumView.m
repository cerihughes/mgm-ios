//
//  MGMRankedAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 28/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMRankedAlbumView.h"

#define LISTENERS_FORMAT @"%d geeks listening this week"

@interface MGMRankedAlbumView ()

@property (strong) UILabel* rankLabel;
@property (strong) UILabel* listenersLabel;

@end

@implementation MGMRankedAlbumView
{
    NSUInteger _listeners;
}

- (void) commonInit
{
    [super commonInit];

    CGSize size = self.frame.size;
    CGFloat width = size.width - 4;
    CGFloat height = size.height - 4;

    CGFloat fontSize = height / 4 / 1.25;
    self.rankLabel = [MGMRankedAlbumView createLabelWithRect:CGRectMake(2, 2, width / 4, height / 4) fontName:DEFAULT_FONT_BOLD fontSize:fontSize];
    self.rankLabel.alpha = 0.75;
    self.rankLabel.textColor = [UIColor yellowColor];
    [self addSubview:self.rankLabel];

    CGFloat textParentViewWidth = width - 4;
    CGFloat textParentViewHeight = height / 4;
    CGFloat textWidth = textParentViewWidth - 4;
    CGFloat textHeight = textParentViewHeight / 3;
    fontSize = textHeight / 1.25;
    self.listenersLabel = [MGMRankedAlbumView createLabelWithRect:CGRectMake(2, height - textHeight, textWidth, textHeight) fontName:DEFAULT_FONT_ITALIC fontSize:fontSize];
    [self addSubview:self.listenersLabel];
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
