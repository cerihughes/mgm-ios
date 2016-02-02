//
//  MGMAlbumScoresView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumScoresView.h"

#import "MGMAlbumGridView.h"

@interface MGMAlbumScoresView ()

@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UISegmentedControl* segmentedControl;

@end

@implementation MGMAlbumScoresView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@""];

    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Classic Albums", @"New Albums", @"All Albums"]];
    [_segmentedControl addTarget:self action:@selector(controlChanged:) forControlEvents:UIControlEventValueChanged];

    navigationItem.titleView = _segmentedControl;
    [_navigationBar pushNavigationItem:navigationItem animated:YES];

    _albumGridView = [[MGMAlbumGridView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + 64, self.frame.size.width, self.frame.size.height - (64 + self.tabBarHeight))];

    [self addSubview:_albumGridView];
    [self addSubview:_navigationBar];
}

- (void) controlChanged:(UISegmentedControl*)sender
{
    [self.delegate selectionChanged:(MGMAlbumScoresViewSelection)sender.selectedSegmentIndex];
}

- (void) setSelection:(MGMAlbumScoresViewSelection)selection
{
    self.segmentedControl.selectedSegmentIndex = selection;

    // Fire the delegate, as this won't happen automatically when setting.
    [self controlChanged:self.segmentedControl];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.navigationBar.frame = CGRectMake(0, 20, 768, 44);
}

@end
