//
//  ViewController.m
//  MGMViewTest
//
//  Created by Ceri Hughes on 06/09/2013.
//  Copyright (c) 2013 alicecallsbob. All rights reserved.
//

#import "ViewController.h"

#import "MGMAlbumView.h"

typedef enum
{
    AlbumStateFirstImage,
    AlbumStatePending,
    AlbumStateSecondImage,
    AlbumStateThirdImage
}
AlbumState;

@interface ViewController () <MGMAlbumViewDelegate>

@property (strong) MGMAlbumView* albumView1;
@property (strong) MGMAlbumView* albumView2;

@property AlbumState album1State;
@property AlbumState album2State;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.albumView1 = [[MGMAlbumView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    self.albumView1.pressable = YES;
    self.albumView1.delegate = self;
    
    self.albumView2 = [[MGMAlbumView alloc] initWithFrame:CGRectMake(20, 220, 200, 200)];
    self.albumView2.pressable = YES;
    self.albumView2.delegate = self;

    [self.view addSubview:self.albumView1];
    [self.view addSubview:self.albumView2];

    [self albumView:self.albumView1 progressToState:AlbumStateFirstImage];
    [self albumView:self.albumView2 progressToState:AlbumStateSecondImage];
}

- (void) albumView:(MGMAlbumView*)albumView progressToState:(AlbumState)state
{
    if (state == AlbumStatePending)
    {
        albumView.activityInProgress = YES;
    }
    else
    {
        albumView.activityInProgress = NO;
        NSString* imageName = (state == AlbumStateFirstImage) ? @"album1.png" : (state == AlbumStateSecondImage ? @"album2.png" : @"album3.png");
        UIImage* image = [UIImage imageNamed:imageName];
        albumView.detailViewShowing = (state == AlbumStateSecondImage);
        if (state == AlbumStateThirdImage)
        {
            [albumView fadeOutAndRenderImage:image];
        }
        else
        {
            [albumView renderImage:image];
        }
    }
}

#pragma mark -
#pragma mark MGMAlbumViewDelegate

- (void) albumPressed:(MGMAlbumView*)albumView
{
    BOOL isAlbum1 = (albumView == self.albumView1);
    AlbumState existingState = isAlbum1 ? self.album1State : self.album2State;
    existingState++;
    existingState %= 4;
    [self albumView:albumView progressToState:existingState];
    if (isAlbum1)
    {
        self.album1State = existingState;
    }
    else
    {
        self.album2State = existingState;
    }
}

- (void) detailPressed:(MGMAlbumView*)albumView
{
    
}

@end
