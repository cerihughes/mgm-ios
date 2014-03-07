//
//  MGMPlayerSelectionView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlayerSelectionView.h"

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

@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UIButton* closeButton;
@property (readonly) UILabel* titleLabel;
@property (readonly) UILabel* subtitleLabel;

@end

@implementation MGMPlayerSelectionView
{
    MGMPlayerSelectionMode _mode;
}

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    _titleLabel = [MGMView boldSubtitleLabelWithText:@""];
    _titleLabel.numberOfLines = 2;
    _subtitleLabel = [MGMView italicSubtitleLabelWithText:@""];
    _subtitleLabel.numberOfLines = 2;

    [self addSubview:_titleLabel];
    [self addSubview:_subtitleLabel];
    [self addSubview:self.groupView];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Player Selection"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [_navigationBar pushNavigationItem:navigationItem animated:YES];

    [self addSubview:_navigationBar];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    _closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_closeButton];
}

- (MGMPlayerSelectionMode) mode
{
    return _mode;
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

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);

    CGSize size = self.frame.size;
    CGFloat width = size.width;
    self.titleLabel.frame = CGRectMake(20, 100, width - 40, 60);
    self.subtitleLabel.frame = CGRectMake(20, 160, width - 40, 60);

    CGFloat remainingHeight = self.frame.size.height - 220;
    CGFloat groupY = 220 + ((remainingHeight - 200) / 2);
    self.groupView.frame = CGRectMake(0, groupY, 320, 200);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    CGSize size = self.frame.size;
    CGFloat width = size.width;
    self.titleLabel.frame = CGRectMake(20, 60, width - 40, 60);
    self.subtitleLabel.frame = CGRectMake(20, 120, width - 40, 60);

    self.closeButton.frame = CGRectMake(447, 20, 74, 44);
    self.groupView.frame = CGRectMake(0, 250, 540, 320);
}

@end
