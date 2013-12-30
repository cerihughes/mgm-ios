//
//  ViewController2.m
//  MGMViewTest
//
//  Created by Ceri Hughes on 30/12/2013.
//  Copyright (c) 2013 alicecallsbob. All rights reserved.
//

#import "ViewController2.h"

#import "MGMPlayerGroupView.h"

@interface ViewController2 ()

@property (strong) MGMPlayerGroupView* groupView;

@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.groupView = [[MGMPlayerGroupView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.groupView];

    [self.groupView addServiceType:MGMAlbumServiceTypeDeezer withImage:[UIImage imageNamed:@"deezer.png"] label:@"Deezer" available:YES];
    [self.groupView addServiceType:MGMAlbumServiceTypeItunes withImage:[UIImage imageNamed:@"itunes.png"] label:@"iTunes" available:NO];
    [self.groupView addServiceType:MGMAlbumServiceTypeLastFm withImage:[UIImage imageNamed:@"lastfm.png"] label:@"last.fm" available:YES];
    [self.groupView addServiceType:MGMAlbumServiceTypeSpotify withImage:[UIImage imageNamed:@"spotify.png"] label:@"Spotify" available:NO];
    [self.groupView addServiceType:MGMAlbumServiceTypeWikipedia withImage:[UIImage imageNamed:@"wikipedia.png"] label:@"Wikipedia" available:YES];
    [self.groupView addServiceType:MGMAlbumServiceTypeYouTube withImage:[UIImage imageNamed:@"youtube.png"] label:@"YouTube" available:NO];
}

#pragma mark -
#pragma mark MGMPlayerGroupViewDelegate

- (void) serviceTypeSelected:(MGMAlbumServiceType)serviceType
{
    NSLog(@"%d pressed", serviceType);
}

@end
