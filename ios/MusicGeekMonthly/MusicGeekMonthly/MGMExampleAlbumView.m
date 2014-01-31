//
//  MGMExampleAlbumView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMExampleAlbumView.h"

#define EXAMPLE_TEXT @"You can see all available options for an album by pressing the 'detail' button at any time"

@interface MGMExampleAlbumView () <MGMAlbumViewDelegate>

@property (strong) UINavigationBar* navigationBar;
@property (strong) UIButton* gotItButton;
@property (strong) MGMAlbumView* albumView;
@property (strong) UIImageView* imageView;
@property (strong) UILabel* label;

@end

@implementation MGMExampleAlbumView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    self.albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
    self.albumView.animationTime = 0.25;
    self.albumView.pressable = YES;
    self.albumView.delegate = self;
    self.albumView.detailViewShowing = YES;

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.image = [UIImage imageNamed:@"arrow.png"];

    self.label = [MGMView italicTitleLabelWithText:EXAMPLE_TEXT];
    self.label.numberOfLines = 5;

    [self addSubview:self.albumView];
    [self addSubview:self.imageView];
    [self addSubview:self.label];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Album Example"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Got it!" style:UIBarButtonItemStyleBordered target:self action:@selector(gotItButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [self.navigationBar pushNavigationItem:navigationItem animated:YES];

    [self addSubview:self.navigationBar];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    self.gotItButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.gotItButton setTitle:@"Got it!" forState:UIControlStateNormal];
    [self.gotItButton addTarget:self action:@selector(gotItButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.gotItButton];
}

- (void) gotItButtonPressed:(id)sender
{
    [self.delegate gotIt];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    self.albumView.frame = CGRectMake(40, 65, 240, 240);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.gotItButton.frame = CGRectMake(447, 20, 74, 44);
    self.albumView.frame = CGRectMake(145, 75, 250, 250);
    self.imageView.frame = CGRectMake(170, 0, 105*2, 235*2);

    CGSize size = self.frame.size;
    self.label.frame = CGRectMake(10, 400, size.width - 20, 200);
}

#pragma mark -
#pragma mark MGMAlbumViewDelegate

- (void) albumPressed:(MGMAlbumView*)albumView
{
    [self.delegate gotIt];
}

- (void) detailPressed:(MGMAlbumView*)albumView
{
    [self.delegate gotIt];
}

@end
