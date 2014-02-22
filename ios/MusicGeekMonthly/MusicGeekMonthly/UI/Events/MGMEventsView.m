//
//  MGMEventsView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsView.h"

#import "MGMGridManager.h"

@interface MGMEventsView ()

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
    
    [self addSubview:self.navigationBar];
    [self addSubview:self.classicAlbumLabel];
    [self addSubview:self.classicAlbumView];
    [self addSubview:self.newlyReleasedAlbumLabel];
    [self addSubview:self.newlyReleasedAlbumView];
    [self addSubview:self.playlistLabel];
}

- (void) setTitle:(NSString*)title
{
    self.navigationItem.title = title;
}

- (void) moreButtonPressed:(id)sender
{
    [self.delegate moreButtonPressed:sender];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    // Resize the album view for new data...
    NSUInteger albumCount = self.screenSize == MGMViewScreenSizeiPad ? 16 : 9;
    NSUInteger rowCount = self.screenSize == MGMViewScreenSizeiPad ? 4 : 3;
    CGFloat albumSize = self.playlistView.frame.size.width / rowCount;
    NSArray* gridData = [MGMGridManager rectsForRows:rowCount columns:rowCount size:albumSize count:albumCount];

    for (NSUInteger i = 0; i < albumCount; i++)
    {
        NSValue* value = [gridData objectAtIndex:i];
        CGRect frame = [value CGRectValue];
        [self.playlistView setAlbumFrame:frame forRank:i + 1];
    }

    [self.playlistView setActivityInProgressForAllRanks:YES];

}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    self.classicAlbumLabel.frame = CGRectZero;
    self.classicAlbumView.frame = CGRectMake(0, 64, 160, 160);
    self.newlyReleasedAlbumLabel.frame = CGRectZero;
    self.newlyReleasedAlbumView.frame = CGRectMake(160, 64, 160, 160);
    self.playlistLabel.frame = CGRectZero;
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
    self.playlistView.frame = CGRectMake(92, 420, 584, 584);
}

@end
