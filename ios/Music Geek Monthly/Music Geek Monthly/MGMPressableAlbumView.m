//
//  MGMAlbumView.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 16/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPressableAlbumView.h"

@interface MGMPressableAlbumView ()

@property (strong) UIButton* detailButton;
@property (strong) UILabel* artistLabel;
@property (strong) UILabel* albumLabel;
@property (strong) UIActivityIndicatorView* activityIndicatorView;

@end

@implementation MGMPressableAlbumView

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
    
    CGSize size = self.frame.size;
    CGFloat width = size.width - 4;
    CGFloat height = size.height - 4;

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView setContentMode:UIViewContentModeCenter];
    self.activityInProgress = NO;

    self.detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    CGFloat detailWidth = 34;
    CGFloat detailHeight = detailWidth;
    CGFloat detailX = width - (detailWidth + 10);
    CGFloat detailY = 10;
    self.detailButton.frame = CGRectMake(detailX, detailY, detailWidth, detailHeight);
    self.detailButton.alpha = 0;
    self.detailButton.hidden = YES;
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
    CGFloat fontSize = textHeight / 1.25;
    self.artistLabel = [MGMPressableAlbumView createLabelWithRect:CGRectMake(2, 0, textWidth, textHeight) fontName:DEFAULT_FONT_BOLD fontSize:fontSize];
    [textParentView addSubview:self.artistLabel];

    self.albumLabel = [MGMPressableAlbumView createLabelWithRect:CGRectMake(2, textHeight, textWidth, textHeight) fontName:DEFAULT_FONT_MEDIUM fontSize:fontSize];
    [textParentView addSubview:self.albumLabel];

    [self addSubview:textParentView];
    [self addSubview:self.activityIndicatorView];
    [self addSubview:self.detailButton];
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

- (void) imagePressed:(id)receiver
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
    if (activityInProgress)
    {
        [self.activityIndicatorView startAnimating];
        [UIView animateWithDuration:self.animationTime * 2 animations:^
        {
            self.detailButton.alpha = 0;
        }
        completion:^(BOOL finished)
        {
            self.detailButton.userInteractionEnabled = NO;
        }];
    }
    else
    {
        [self.activityIndicatorView stopAnimating];
        self.detailButton.userInteractionEnabled = YES;
        [UIView animateWithDuration:self.animationTime * 2 animations:^
        {
            self.detailButton.alpha = 1;
            self.activityIndicatorView.center = self.center;
        }];
    }
}

@end
