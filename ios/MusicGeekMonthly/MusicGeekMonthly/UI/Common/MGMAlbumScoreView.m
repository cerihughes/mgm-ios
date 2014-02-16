//
//  MGMAlbumScoreView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoreView.h"

@interface MGMAlbumScoreView ()

@property (strong) UIImageView* imageView;
@property (strong) UILabel* scoreLabel;

@end

@implementation MGMAlbumScoreView

- (void) commonInit
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.image = [UIImage imageNamed:@"gold_bar.png"];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.backgroundColor = [UIColor clearColor];
    self.scoreLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:15];
    self.scoreLabel.adjustsFontSizeToFitWidth = YES;

    [self addSubview:self.imageView];
    [self.imageView addSubview:self.scoreLabel];

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
