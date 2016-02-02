//
//  MGMAlbumDetailView.m
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailView.h"

#import "MGMAlbumView.h"
#import "MGMPlayerGroupView.h"

@interface MGMAlbumDetailView ()

@property (readonly) UINavigationBar* navigationBar;
@property (readonly) UIButton* cancelButton;

@end

@implementation MGMAlbumDetailView

@dynamic delegate;

- (void) commonInit
{
    [super commonInit];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _albumView = [[MGMAlbumView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.groupView];
    [self addSubview:_albumView];
}

- (void) commonInitIphone
{
    [super commonInitIphone];
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Album Detail"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [_navigationBar pushNavigationItem:navigationItem animated:YES];
    
    [self addSubview:_navigationBar];
}

- (void) commonInitIpad
{
    [super commonInitIpad];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_cancelButton];
}

- (void) cancelButtonPressed:(id)sender
{
    [self.delegate cancelButtonPressed:sender];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    self.albumView.frame = CGRectMake(40, 65, 240, 240);

    CGFloat remainingHeight = self.frame.size.height - (65 + 240);
    self.groupView.frame = CGRectMake(0, 65 + 240, 320, remainingHeight);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.cancelButton.frame = CGRectMake(447, 20, 74, 44);
    self.albumView.frame = CGRectMake(145, 20, 250, 250);
    self.groupView.frame = CGRectMake(0, 291, 540, 329);
}

@end
