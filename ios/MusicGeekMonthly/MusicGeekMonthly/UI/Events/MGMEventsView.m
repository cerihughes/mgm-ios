//
//  MGMEventsView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsView.h"

@interface MGMEventsView ()

@property (readonly) UIView* parentView;
@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UINavigationItem* navigationItem;

@end

@implementation MGMEventsView

- (void) commonInit
{
    [super commonInit];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    _navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"More..." style:UIBarButtonItemStyleBordered target:self action:@selector(moreButtonPressed:)];
    [_navigationItem setRightBarButtonItem:bbi];
    [_navigationBar pushNavigationItem:_navigationItem animated:YES];

    [_parentView addSubview:self.classicAlbumLabel];
    [_parentView addSubview:self.classicAlbumView];
    [_parentView addSubview:self.newlyReleasedAlbumLabel];
    [_parentView addSubview:self.newlyReleasedAlbumView];
    [_parentView addSubview:self.playlistLabel];
    [_parentView addSubview:self.playlistView];
    [self addSubview:_parentView];
    [self addSubview:_navigationBar];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    CGRect frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 20);
    _parentView = [[UIScrollView alloc] initWithFrame:frame];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    _parentView = [[UIView alloc] initWithFrame:self.frame];
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
