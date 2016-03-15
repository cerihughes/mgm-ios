//
//  MGMPlayerSelectionView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlayerSelectionView.h"

#import "MGMPlayerGroupView.h"

#define NO_PLAYER_TITLE @"Welcome to the Music Geek Monthly app"
#define NO_PLAYER_SUBTITLE @"Please choose a default app for playing music"

#define DELETED_PLAYER_TITLE @"Your default music player has been removed"
#define DELETED_PLAYER_SUBTITLE @"Please choose a new default app for playing music"

#define NEW_PLAYERS_TITLE @"New music players detected"
#define NEW_PLAYERS_SUBTITLE @"Select it to make it the default player"

#define CELL_ID @"PLAYER_SELECTION_CELL_ID"

@interface MGMPlayerSelectionViewTableData : NSObject

@property MGMAlbumServiceType serviceType;
@property (copy) NSString* text;
@property (strong) UIImage* image;

@end

@implementation MGMPlayerSelectionViewTableData

@end

@interface MGMPlayerSelectionView ()

@property (readonly) UILabel* titleLabel;
@property (readonly) UILabel* subtitleLabel;

@end

@implementation MGMPlayerSelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _titleLabel = [MGMView boldSubtitleLabelWithText:@""];
        _titleLabel.numberOfLines = 2;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _subtitleLabel = [MGMView italicSubtitleLabelWithText:@""];
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _subtitleLabel.numberOfLines = 2;

        [self addSubview:_titleLabel];
        [self addSubview:_subtitleLabel];
        [self addSubview:self.groupView];
    }
    return self;
}

- (void) setMode:(MGMPlayerSelectionMode)mode
{
    _mode = mode;

    NSString* title;
    NSString* subtitle;
    switch (mode)
    {
        case MGMPlayerSelectionModeNone:
        default:
            title = @"";
            break;
        case MGMPlayerSelectionModeNoPlayer:
            title = NO_PLAYER_TITLE;
            subtitle = NO_PLAYER_SUBTITLE;
            break;
        case MGMPlayerSelectionModePlayerRemoved:
            title = DELETED_PLAYER_TITLE;
            subtitle = DELETED_PLAYER_SUBTITLE;
            break;
        case MGMPlayerSelectionModeNewPlayers:
            title = NEW_PLAYERS_TITLE;
            subtitle = NEW_PLAYERS_SUBTITLE;
            break;
    }

    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
}

- (void) closeButtonPressed:(UIButton*)sender
{
    [self.delegate playerSelectionComplete:(MGMAlbumServiceTypeNone)];
}

@end

@interface MGMPlayerSelectionViewPhone ()

@property (readonly) UINavigationBar* navigationBar;

@end

@implementation MGMPlayerSelectionViewPhone

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Player Selection"];
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPressed:)];
        [navigationItem setRightBarButtonItem:bbi];
        [_navigationBar pushNavigationItem:navigationItem animated:YES];

        [self addSubview:_navigationBar];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Navigation bar
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:20]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:44]];

    // Title label
    CGFloat textInset = 20;
    CGFloat textHeight = 60;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:-2 * textInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.navigationBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:5]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:textHeight]];

    // Subtitle label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0]];

    // Group view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:5]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end

@interface MGMPlayerSelectionViewPad ()

@property (readonly) UIButton* closeButton;

@end

@implementation MGMPlayerSelectionViewPad

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_closeButton];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Cancel button
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:-20]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:20]];

    // Title label
    CGFloat textInset = 20;
    CGFloat textHeight = 60;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:-2 * textInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.closeButton
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:20]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:textHeight]];

    // Subtitle label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.titleLabel
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0]];

    // Group view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.subtitleLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:20]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.groupView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
