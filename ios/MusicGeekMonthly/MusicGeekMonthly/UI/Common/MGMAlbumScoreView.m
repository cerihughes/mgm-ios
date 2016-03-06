//
//  MGMAlbumScoreView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 10/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoreView.h"

#import "NSLayoutConstraint+MGM.h"

@interface MGMAlbumScoreView ()

@property (readonly) UIImageView* imageView;
@property (readonly) UILabel* scoreLabel;

@end

@implementation MGMAlbumScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"gold_bar.png"];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;

        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:15];
        _scoreLabel.adjustsFontSizeToFitWidth = YES;
        _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_imageView];
        [_imageView addSubview:_scoreLabel];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Image view
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithItem:self.imageView
                                                thatMatchCenterAndSizeOfItem:self]];

    // Score label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.scoreLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0/3.0
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

- (NSString*) score
{
    return self.scoreLabel.text;
}

- (void) setScore:(NSString*)score
{
    self.scoreLabel.text = score;
}

@end
