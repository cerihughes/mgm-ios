//
//  MGMPlayerSelectionView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlayerSelectionView.h"

#define NO_PLAYER_TEXT @"Welcome to the Music Geek Monthly app. Please choose a default app for playing music."
#define DELETED_PLAYER_TEXT @"Your default music player has been removed. Please choose a new default app for playing music."
#define NEW_PLAYERS_TEXT @"New music players detected. Select this from the following if you'd like to make it the default player."

#define CELL_ID @"PLAYER_SELECTION_CELL_ID"

@interface MGMPlayerSelectionViewTableData : NSObject

@property MGMAlbumServiceType serviceType;
@property (strong) NSString* text;
@property (strong) UIImage* image;

@end

@implementation MGMPlayerSelectionViewTableData

@end

@interface MGMPlayerSelectionView ()

@property (strong) UINavigationBar* navigationBar;
@property (strong) UIButton* closeButton;
@property (strong) UILabel* titleLabel;

@end

@implementation MGMPlayerSelectionView
{
    MGMPlayerSelectionMode _mode;
}

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    self.titleLabel = [MGMView boldLabelWithText:@""];

    [self addSubview:self.titleLabel];
    [self addSubview:self.groupView];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Player Selection"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [self.navigationBar pushNavigationItem:navigationItem animated:YES];

    [self addSubview:self.navigationBar];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.closeButton];
}

- (MGMPlayerSelectionMode) mode
{
    return _mode;
}

- (void) setMode:(MGMPlayerSelectionMode)mode
{
    _mode = mode;

    NSString* text;
    switch (mode)
    {
        case MGMPlayerSelectionModeNone:
        default:
            text = @"";
            break;
        case MGMPlayerSelectionModeNoPlayer:
            text = NO_PLAYER_TEXT;
            break;
        case MGMPlayerSelectionModePlayerRemoved:
            text = DELETED_PLAYER_TEXT;
            break;
        case MGMPlayerSelectionModeNewPlayers:
            text = NEW_PLAYERS_TEXT;
            break;
    }

    self.titleLabel.text = text;
}

- (void) closeButtonPressed:(UIButton*)sender
{
    [self.delegate playerSelectionComplete:(MGMAlbumServiceTypeNone)];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    CGSize size = self.frame.size;
    CGFloat width = size.width;

    self.titleLabel.frame = CGRectMake(20, 60, width - 40, 60);
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);

    CGFloat remainingHeight = self.frame.size.height - (65 + 240);
    self.groupView.frame = CGRectMake(0, 65 + 240, 320, remainingHeight);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.closeButton.frame = CGRectMake(447, 20, 74, 44);
    self.groupView.frame = CGRectMake(0, 291, 540, 329);
}

@end
