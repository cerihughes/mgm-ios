//
//  MGMWeeklyChartView.m
//  MusicGeekMonthly
//
//  Created by Home on 05/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWeeklyChartView.h"

@interface MGMWeeklyChartView ()

@property (strong) UINavigationBar* navigationBar;
@property (strong) UINavigationItem* navigationItem;
@property (strong) MGMWeeklyChartAlbumsView* albumsView;

@end

@implementation MGMWeeklyChartView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    self.navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"More..." style:UIBarButtonItemStyleBordered target:self action:@selector(moreButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:bbi];
    [self.navigationBar pushNavigationItem:self.navigationItem animated:YES];

    self.albumsView = [[MGMWeeklyChartAlbumsView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + 64, self.frame.size.width, self.frame.size.height - (64 + self.tabBarHeight))];

    [self addSubview:self.navigationBar];
    [self addSubview:self.albumsView];
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
