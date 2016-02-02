//
//  MGMWeeklyChartView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartView.h"

#import "MGMAlbumGridView.h"

@interface MGMWeeklyChartView ()

@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UINavigationItem* navigationItem;

@end

@implementation MGMWeeklyChartView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    _navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"More..." style:UIBarButtonItemStyleBordered target:self action:@selector(moreButtonPressed:)];
    [_navigationItem setRightBarButtonItem:bbi];
    [_navigationBar pushNavigationItem:_navigationItem animated:YES];

    _albumGridView = [[MGMAlbumGridView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + 64, self.frame.size.width, self.frame.size.height - (64 + self.tabBarHeight))];

    [self addSubview:_navigationBar];
    [self addSubview:_albumGridView];
}

- (void) setTitle:(NSString*)title
{
    self.navigationItem.title = title;
}

- (void) moreButtonPressed:(id)sender
{
    [self.delegate moreButtonPressed:sender];
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
