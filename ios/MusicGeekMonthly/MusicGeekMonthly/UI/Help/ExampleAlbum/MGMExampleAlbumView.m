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

@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UIButton* gotItButton;
@property (readonly) UIImageView* imageView;
@property (readonly) UILabel* label;

@end

@implementation MGMExampleAlbumView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    _albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
    _albumView.animationTime = 0.25;
    _albumView.pressable = YES;
    _albumView.delegate = self;
    _albumView.detailViewShowing = YES;

    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image = [UIImage imageNamed:@"arrow.png"];

    _label = [MGMView italicTitleLabelWithText:EXAMPLE_TEXT];
    _label.numberOfLines = 5;

    [self addSubview:_albumView];
    [self addSubview:_imageView];
    [self addSubview:_label];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Album Example"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Got it!" style:UIBarButtonItemStyleBordered target:self action:@selector(gotItButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [_navigationBar pushNavigationItem:navigationItem animated:YES];

    [self addSubview:_navigationBar];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    _gotItButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_gotItButton setTitle:@"Got it!" forState:UIControlStateNormal];
    [_gotItButton addTarget:self action:@selector(gotItButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gotItButton];
}

- (void) gotItButtonPressed:(id)sender
{
    [self.delegate gotIt];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    self.albumView.frame = CGRectMake(40, 90, 240, 240);
    self.imageView.frame = CGRectMake(100, 35, 105*1.5, 235*1.5);

    CGSize size = self.frame.size;
    self.label.frame = CGRectMake(10, 320, size.width - 20, 150);
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
