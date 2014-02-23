//
//  MGMEventsView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsView.h"

@interface MGMEventsView ()

@property (strong) UIView* parentView;
@property (strong) UINavigationBar* navigationBar;
@property (strong) UINavigationItem* navigationItem;

@end

@implementation MGMEventsView

- (void) commonInit
{
    [super commonInit];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    self.navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"More..." style:UIBarButtonItemStyleBordered target:self action:@selector(moreButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:bbi];
    [self.navigationBar pushNavigationItem:self.navigationItem animated:YES];

    [self.parentView addSubview:self.classicAlbumLabel];
    [self.parentView addSubview:self.classicAlbumView];
    [self.parentView addSubview:self.newlyReleasedAlbumLabel];
    [self.parentView addSubview:self.newlyReleasedAlbumView];
    [self.parentView addSubview:self.playlistLabel];
    [self.parentView addSubview:self.playlistView];
    [self addSubview:self.parentView];
    [self addSubview:self.navigationBar];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    CGRect frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 20);
    self.parentView = [[UIScrollView alloc] initWithFrame:frame];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    self.parentView = [[UIView alloc] initWithFrame:self.frame];
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
    self.classicAlbumLabel.frame = CGRectMake(0, 70, 160, 21);
    self.newlyReleasedAlbumLabel.frame = CGRectMake(160, 70, 160, 21);
    self.classicAlbumView.frame = CGRectMake(0, 100, 160, 160);
    self.newlyReleasedAlbumView.frame = CGRectMake(160, 100, 160, 160);

    UIView* lastView = self.newlyReleasedAlbumView;
    if (self.playlistLabel.hidden == NO)
    {
        self.playlistLabel.frame = CGRectMake(0, 280, 320, 21);
        self.playlistView.frame = CGRectMake(50, 310, 220, 220);
        lastView = self.playlistView;
    }

    // Need to create a contentRect that's got space to scroll over the tab bar...
    CGRect contentRect = CGRectUnion(CGRectZero, lastView.frame);
    contentRect = CGRectInset(contentRect, 0, -self.tabBarHeight);

    UIScrollView* scrollView = (UIScrollView*)self.parentView;
    scrollView.contentSize = contentRect.size;
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];
    
    self.navigationBar.frame = CGRectMake(0, 20, 768, 44);
    self.classicAlbumLabel.frame = CGRectMake(20, 90, 364, 30);;
    self.classicAlbumView.frame = CGRectMake(104, 130, 196, 196);
    self.newlyReleasedAlbumLabel.frame = CGRectMake(384, 90, 364, 30);;
    self.newlyReleasedAlbumView.frame = CGRectMake(468, 130, 196, 196);
    self.playlistLabel.frame = CGRectMake(20, 360, 728, 30);
    self.playlistView.frame = CGRectMake(120, 420, 528, 528);
}

@end
