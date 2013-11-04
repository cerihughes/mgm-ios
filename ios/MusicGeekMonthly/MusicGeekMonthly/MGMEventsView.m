//
//  MGMEventsView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsView.h"

@interface MGMEventsView ()

@property (strong) UINavigationBar* navigationBar;
@property (strong) UINavigationItem* navigationItem;
@property (strong) UIWebView* playlistWebView;

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
    
    self.playlistWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.navigationBar];
    [self addSubview:self.classicAlbumView];
    [self addSubview:self.newlyReleasedAlbumView];
    [self addSubview:self.playlistWebView];
}

- (void) setTitle:(NSString*)title
{
    self.navigationItem.title = title;
}

- (void) setPlaylistUrl:(NSString*)playlistUrl
{
    NSURL* url = [NSURL URLWithString:playlistUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.playlistWebView loadRequest:request];
}

- (void) moreButtonPressed:(id)sender
{
    [self.delegate moreButtonPressed:sender];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];
    
    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    self.classicAlbumView.frame = CGRectMake(0, 64, 160, 160);
    self.newlyReleasedAlbumView.frame = CGRectMake(160, 64, 160, 160);
    
    CGFloat remainingHeight = self.frame.size.height - (224 + 49); // Tab bar is 49
    self.playlistWebView.frame = CGRectMake(0, 224, 320, remainingHeight);
}

@end
