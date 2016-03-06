//
//  MGMAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 01/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumView.h"

#import "MGMAlbumScoreView.h"
#import "NSLayoutConstraint+MGM.h"

#define LISTENER_FORMAT @"%d geek listening this week"
#define LISTENERS_FORMAT @"%d geeks listening this week"

@interface MGMAlbumView ()

@property CGFloat alphaOff;
@property (readonly) UIButton* button;
@property (readonly) UIButton* detailButton;
@property (readonly) UIView* textParentView;
@property (readonly) UILabel* artistLabel;
@property (readonly) UILabel* albumLabel;
@property (readonly) UIActivityIndicatorView* activityIndicatorView;
@property (readonly) UILabel* rankLabel;
@property (readonly) UILabel* listenersLabel;
@property (readonly) MGMAlbumScoreView* albumScoreView;

@end

@implementation MGMAlbumView
{
    NSUInteger _rank;
    NSUInteger _listeners;
    CGFloat _score;
}

+ (UILabel*) createLabel
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(2, 2);
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _alphaOff = 0.0f;
        _alphaOn = 1.0f;
        _animationTime = 1;

        _button = [MGMView shadowedButtonWithText:nil image:nil];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.alpha = self.alphaOff;
        _button.backgroundColor = [UIColor whiteColor];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.pressable = NO;

        _rankLabel = [MGMAlbumView createLabel];
        _rankLabel.alpha = 0.75;
        _rankLabel.textColor = [UIColor yellowColor];

        _albumScoreView = [[MGMAlbumScoreView alloc] initWithFrame:CGRectZero];
        _albumScoreView.hidden = YES;
        _albumScoreView.translatesAutoresizingMaskIntoConstraints = NO;

        _detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        _detailButton.translatesAutoresizingMaskIntoConstraints = NO;
        _detailButton.frame = CGRectZero;
        _detailButton.alpha = 0;
        [_detailButton addTarget:self action:@selector(detailPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.detailViewShowing = NO;

        _textParentView = [[UIView alloc] initWithFrame:CGRectZero];
        _textParentView.translatesAutoresizingMaskIntoConstraints = NO;
        _textParentView.backgroundColor = [UIColor clearColor];

        _artistLabel = [MGMAlbumView createLabel];
        _albumLabel = [MGMAlbumView createLabel];
        _listenersLabel = [MGMAlbumView createLabel];

        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.frame = frame;
        _activityIndicatorView.userInteractionEnabled = NO;
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        self.activityInProgress = NO;

        [self addSubview:_button];
        [_button addSubview:_rankLabel];
        [_button addSubview:_albumScoreView];

        [_button addSubview:_textParentView];
        [_textParentView addSubview:_artistLabel];
        [_textParentView addSubview:_albumLabel];
        [_textParentView addSubview:_listenersLabel];

        [_button addSubview:_detailButton];
        [self addSubview:_activityIndicatorView];
    }
    return self;
}

- (BOOL) pressable
{
    return self.button.userInteractionEnabled;
}

- (void) setPressable:(BOOL)pressable
{
    self.button.userInteractionEnabled = pressable;
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

- (void) buttonPressed:(id)receiver
{
    [self.delegate albumPressed:self];
}

- (void) detailPressed:(id)receiver
{
    [self.delegate detailPressed:self];
}

- (BOOL) activityInProgress
{
    return self.activityIndicatorView.hidden == NO;
}

- (void) setActivityInProgress:(BOOL)activityInProgress
{
    [UIView animateWithDuration:self.animationTime animations:^
    {
        if (activityInProgress)
        {
            [self.activityIndicatorView startAnimating];
            self.button.alpha = self.alphaOff;
            self.backgroundColor = [UIColor blackColor];
        }
        else
        {
            [self.activityIndicatorView stopAnimating];
            self.backgroundColor = [UIColor whiteColor];
        }
    }];
}

- (BOOL) detailViewShowing
{
    return self.detailButton.alpha == self.alphaOn;
}

- (void) setDetailViewShowing:(BOOL)detailViewShowing
{
    self.detailButton.userInteractionEnabled = detailViewShowing;
    CGFloat newAlpha = detailViewShowing ? self.alphaOn : self.alphaOff;
    self.detailButton.alpha = newAlpha;
}

- (NSUInteger) rank
{
    return _rank;
}

- (void) setRank:(NSUInteger)rank
{
    self.rankLabel.hidden = (rank == 0);
    self.rankLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)rank];
    _rank = rank;
}

- (NSUInteger) listeners
{
    return _listeners;
}

- (void) setListeners:(NSUInteger)listeners
{
    self.listenersLabel.hidden = (listeners == 0);
    NSString* format = (listeners == 1) ? LISTENER_FORMAT : LISTENERS_FORMAT;
    self.listenersLabel.text = [NSString stringWithFormat:format, listeners];
    _listeners = listeners;
}

- (CGFloat) score
{
    return _score;
}

- (void) setScore:(CGFloat)score
{
    self.albumScoreView.hidden = (score == 0.0f);
    self.albumScoreView.score = [NSString stringWithFormat:@"%.1f", score];
    _score = score;
}

- (void) renderImageWithNoAnimation:(UIImage*)image
{
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    self.button.alpha = self.alphaOn;
}

- (void) renderImage:(UIImage*)image
{
    [UIView animateWithDuration:self.animationTime animations:^
    {
        [self renderImageWithNoAnimation:image];
    }];
}

- (void) fadeOutAndRenderImage:(UIImage*)image
{
    [UIView animateWithDuration:self.animationTime animations:^
    {
        self.button.alpha = self.alphaOff;
    }
    completion:^(BOOL finished)
    {
        [UIView animateWithDuration:self.animationTime animations:^
        {
            [self renderImageWithNoAnimation:image];
        }];
        [self renderImageWithNoAnimation:image];
    }];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    CGFloat quarterHeight = self.frame.size.height / 4.0;
    CGFloat fontSize = quarterHeight / 1.25;
    self.rankLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:fontSize];

    CGFloat textHeight = quarterHeight / 3;
    fontSize = textHeight / 1.25;

    self.artistLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:fontSize];
    self.albumLabel.font = [UIFont fontWithName:DEFAULT_FONT_MEDIUM size:fontSize];
    self.listenersLabel.font = [UIFont fontWithName:DEFAULT_FONT_ITALIC size:fontSize];
}

- (void) addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Button
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithItem:self.button
                                                thatMatchCenterAndSizeOfItem:self]];

    // Rank label
    CGFloat inset = 2.0;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rankLabel
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:inset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rankLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:inset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rankLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.25
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rankLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.25
                                                         constant:0]];

    // Album score
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumScoreView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumScoreView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumScoreView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.25
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumScoreView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.25
                                                         constant:0]];

    // Detail button
    CGFloat detailInset = 10.0;
    CGFloat detailSize = 34.0;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.detailButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:-detailInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.detailButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:detailInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.detailButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:detailSize]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.detailButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.detailButton
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    // Text parent
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.textParentView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.textParentView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:-inset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.textParentView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:(-2 * inset)]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.textParentView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.25
                                                         constant:0]];

    // Artist label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.artistLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.textParentView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.artistLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.textParentView
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.artistLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.textParentView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:(-2 * inset)]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.artistLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.textParentView
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0/3.0
                                                         constant:0]];

    // Album label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.artistLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.artistLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.artistLabel
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.albumLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.artistLabel
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0]];

    // Listeners label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.listenersLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.listenersLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.listenersLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumLabel
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.listenersLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.albumLabel
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0]];

    // Activity view
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithItem:self.activityIndicatorView
                                                thatMatchCenterAndSizeOfItem:self]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
