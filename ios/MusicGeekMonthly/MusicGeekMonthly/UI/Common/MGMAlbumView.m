//
//  MGMAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 01/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumView.h"

#import "MGMAlbumScoreView.h"

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
    return label;
}

- (void) commonInit
{
    [super commonInit];
    
    self.alphaOff = 0.0f;
    self.alphaOn = 1.0f;
    self.animationTime = 1;
    self.backgroundColor = [UIColor clearColor];
    
    CGSize parentSize = self.frame.size;
    CGRect frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    _button = [MGMView shadowedButtonWithText:nil image:nil];
    _button.frame = frame;
    _button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _button.alpha = self.alphaOff;
    _button.backgroundColor = [UIColor whiteColor];
    [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.pressable = NO;

    _rankLabel = [MGMAlbumView createLabel];
    _rankLabel.alpha = 0.75;
    _rankLabel.textColor = [UIColor yellowColor];

    _albumScoreView = [[MGMAlbumScoreView alloc] initWithFrame:CGRectZero];
    _albumScoreView.hidden = YES;

    _detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    _detailButton.frame = CGRectZero;
    _detailButton.alpha = 0;
    [_detailButton addTarget:self action:@selector(detailPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.detailViewShowing = NO;

    _textParentView = [[UIView alloc] initWithFrame:CGRectZero];
    _textParentView.autoresizesSubviews = YES;
    _textParentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _textParentView.backgroundColor = [UIColor clearColor];

    _artistLabel = [MGMAlbumView createLabel];
    _albumLabel = [MGMAlbumView createLabel];
    _listenersLabel = [MGMAlbumView createLabel];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = frame;
    _activityIndicatorView.userInteractionEnabled = NO;
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

    CGSize parentSize = self.frame.size;
    CGRect frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    self.button.frame = frame;

    CGSize size = self.frame.size;
    CGFloat width = size.width - 4;
    CGFloat height = size.height - 4;

    CGFloat fontSize = height / 4 / 1.25;
    self.rankLabel.frame = CGRectMake(2, 2, width / 4, height / 4);
    self.rankLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:fontSize];

    self.albumScoreView.frame = CGRectMake(parentSize.width * 0.375f, 0, parentSize.width * 0.25f, parentSize.height * 0.25f);

    CGFloat detailWidth = 34;
    CGFloat detailHeight = detailWidth;
    CGFloat detailX = width - (detailWidth + 10);
    CGFloat detailY = 10;
    self.detailButton.frame = CGRectMake(detailX, detailY, detailWidth, detailHeight);

    CGFloat textParentViewHeight = height / 4;
    CGFloat y = height - textParentViewHeight - 2;
    self.textParentView.frame = CGRectMake(2, y, width, textParentViewHeight);

    CGFloat textWidth = width - 4;
    CGFloat textHeight = textParentViewHeight / 3;
    fontSize = textHeight / 1.25;
    self.artistLabel.frame = CGRectMake(2, 0, textWidth, textHeight);
    self.albumLabel.frame = CGRectMake(2, textHeight, textWidth, textHeight);
    self.listenersLabel.frame = CGRectMake(2, 2 * textHeight, textWidth, textHeight);

    self.artistLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:fontSize];
    self.albumLabel.font = [UIFont fontWithName:DEFAULT_FONT_MEDIUM size:fontSize];
    self.listenersLabel.font = [UIFont fontWithName:DEFAULT_FONT_ITALIC size:fontSize];
    
    self.activityIndicatorView.frame = frame;
}

@end
