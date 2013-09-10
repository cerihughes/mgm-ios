//
//  MGMAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 01/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumView.h"

#import "MGMAlbumScoreView.h"

#define LISTENERS_FORMAT @"%d geeks listening this week"

@interface MGMAlbumView ()

@property CGFloat alphaOff;
@property (strong) UIButton* button;
@property (strong) UIButton* detailButton;
@property (strong) UILabel* artistLabel;
@property (strong) UILabel* albumLabel;
@property (strong) UIActivityIndicatorView* activityIndicatorView;
@property (strong) UILabel* rankLabel;
@property (strong) UILabel* listenersLabel;
@property (strong) MGMAlbumScoreView* albumScoreView;

@end

@implementation MGMAlbumView
{
    NSUInteger _rank;
    NSUInteger _listeners;
    CGFloat _score;
}

+ (UILabel*) createLabelWithRect:(CGRect)rect fontName:(NSString*)fontName fontSize:(CGFloat)fontSize
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
    [super commonInit];
    
    self.alphaOff = 0.0f;
    self.alphaOn = 1.0f;
    self.animationTime = 1;
    self.backgroundColor = [UIColor clearColor];
    
    CGSize parentSize = self.frame.size;
    CGRect frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = frame;
    self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.button.alpha = self.alphaOff;
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.pressable = NO;

    CGSize size = self.frame.size;
    CGFloat width = size.width - 4;
    CGFloat height = size.height - 4;

    CGFloat fontSize = height / 4 / 1.25;
    self.rankLabel = [MGMAlbumView createLabelWithRect:CGRectMake(2, 2, width / 4, height / 4) fontName:DEFAULT_FONT_BOLD fontSize:fontSize];
    self.rankLabel.alpha = 0.75;
    self.rankLabel.textColor = [UIColor yellowColor];

    self.albumScoreView = [[MGMAlbumScoreView alloc] initWithFrame:CGRectMake(parentSize.width * 0.375f, 0, parentSize.width * 0.25f, parentSize.height * 0.25f)];
    self.albumScoreView.hidden = YES;

    self.detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    CGFloat detailWidth = 34;
    CGFloat detailHeight = detailWidth;
    CGFloat detailX = width - (detailWidth + 10);
    CGFloat detailY = 10;
    self.detailButton.frame = CGRectMake(detailX, detailY, detailWidth, detailHeight);
    self.detailButton.alpha = 0;
    self.detailViewShowing = NO;
    [self.detailButton addTarget:self action:@selector(detailPressed:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat textParentViewWidth = width - 4;
    CGFloat textParentViewHeight = height / 4;
    CGFloat y = height - textParentViewHeight - 2;
    UIView* textParentView = [[UIView alloc] initWithFrame:CGRectMake(2, y, textParentViewWidth, textParentViewHeight)];
    textParentView.autoresizesSubviews = YES;
    textParentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    textParentView.backgroundColor = [UIColor clearColor];

    CGFloat textWidth = textParentViewWidth - 4;
    CGFloat textHeight = textParentViewHeight / 3;
    fontSize = textHeight / 1.25;
    self.artistLabel = [MGMAlbumView createLabelWithRect:CGRectMake(2, 0, textWidth, textHeight) fontName:DEFAULT_FONT_BOLD fontSize:fontSize];
    self.albumLabel = [MGMAlbumView createLabelWithRect:CGRectMake(2, textHeight, textWidth, textHeight) fontName:DEFAULT_FONT_MEDIUM fontSize:fontSize];
    self.listenersLabel = [MGMAlbumView createLabelWithRect:CGRectMake(2, 2 * textHeight, textWidth, textHeight) fontName:DEFAULT_FONT_ITALIC fontSize:fontSize];

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.frame = frame;
    self.activityIndicatorView.userInteractionEnabled = NO;
    self.activityInProgress = NO;

    [self addSubview:self.button];
    [self.button addSubview:self.rankLabel];
    [self.button addSubview:self.albumScoreView];

    [self.button addSubview:textParentView];
    [textParentView addSubview:self.artistLabel];
    [textParentView addSubview:self.albumLabel];
    [textParentView addSubview:self.listenersLabel];

    [self.button addSubview:self.detailButton];
    [self addSubview:self.activityIndicatorView];
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
            self.backgroundColor = [UIColor clearColor];
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
    self.rankLabel.text = [NSString stringWithFormat:@"%d", rank];
    _rank = rank;
}

- (NSUInteger) listeners
{
    return _listeners;
}

- (void) setListeners:(NSUInteger)listeners
{
    self.listenersLabel.hidden = (listeners == 0);
    self.listenersLabel.text = [NSString stringWithFormat:LISTENERS_FORMAT, listeners];
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
    [self.button setImage:image forState:UIControlStateNormal];
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

@end
