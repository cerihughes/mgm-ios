//
//  MGMAlbumScoreView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoreView.h"

@interface MGMAlbumScoreView ()

@property (readonly) UIImageView* imageView;
@property (readonly) UILabel* scoreLabel;

@end

@implementation MGMAlbumScoreView

- (void) commonInit
{
    [super commonInit];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image = [UIImage imageNamed:@"gold_bar.png"];
    _imageView.backgroundColor = [UIColor clearColor];

    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:15];
    _scoreLabel.adjustsFontSizeToFitWidth = YES;

    [self addSubview:_imageView];
    [_imageView addSubview:_scoreLabel];

    self.backgroundColor = [UIColor clearColor];
}

- (NSString*) score
{
    return self.scoreLabel.text;
}

- (void) setScore:(NSString*)score
{
    self.scoreLabel.text = score;
}

- (void) layoutSubviews
{
    CGSize size = self.frame.size;
    self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    self.scoreLabel.frame = CGRectMake(0, size.height/3.0f, size.width, size.height/3.0);
}

@end
