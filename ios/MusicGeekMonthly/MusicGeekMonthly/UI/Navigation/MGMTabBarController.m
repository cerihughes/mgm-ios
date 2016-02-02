//
//  MGMTabBarController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMTabBarController.h"

#import "MGMAlbumScoresViewController.h"
#import "MGMBackgroundAlbumArtFetcher.h"
#import "MGMEventsViewController.h"
#import "MGMImageHelper.h"
#import "MGMPulsatingAlbumsView.h"
#import "MGMTabbedViewController.h"
#import "MGMTimePeriod.h"
#import "MGMUI.h"
#import "MGMWeeklyChart.h"
#import "MGMWeeklyChartViewController.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMTabBarController () <MGMBackgroundAlbumArtFetcherDelegate, UITabBarControllerDelegate>

@property (strong) MGMPulsatingAlbumsView* albumsView;

@property (weak) MGMUI* ui;
@property NSUInteger backgroundAlbumCount;
@property (strong) MGMBackgroundAlbumArtFetcher* artFetcher;

@end

@implementation MGMTabBarController

- (id) initWithUI:(MGMUI*)ui albumArtCollection:(MGMBackgroundAlbumArtCollection*)albumArtCollection
{
    if (self = [super init])
    {
        self.delegate = self;
        _ui = ui;

        _artFetcher = [[MGMBackgroundAlbumArtFetcher alloc] initWithImageHelper:ui.imageHelper albumArtCollection:albumArtCollection];
        _artFetcher.delegate = self;

        [self createControllers];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.albumsView = [[MGMPulsatingAlbumsView alloc] initWithFrame:self.view.frame];

    self.backgroundAlbumCount = [self setBackgroundAlbumsInRow:4];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.artFetcher renderImages:self.backgroundAlbumCount];
}

- (NSUInteger) setBackgroundAlbumsInRow:(NSUInteger)albumsInRow
{
    [self.albumsView setupAlbumsInRow:4];
    return self.albumsView.albumCount;
}

- (void) renderBackgroundAlbumImage:(UIImage *)image atIndex:(NSUInteger)index animation:(BOOL)animation
{
    if (image == nil)
    {
        image = [self.ui.imageHelper nextDefaultImage];
    }

    [self.albumsView renderImage:image atIndex:index animation:animation];
}

- (void) createControllers
{
    MGMWeeklyChartViewController* weeklyChartViewController = [[MGMWeeklyChartViewController alloc] init];
    weeklyChartViewController.ui = self.ui;
    weeklyChartViewController.title = @"Weekly Charts";
    weeklyChartViewController.albumSelectionDelegate = self.ui;
    weeklyChartViewController.tabBarItem.title = @"Weekly Charts";
    weeklyChartViewController.tabBarItem.image = [UIImage imageNamed:@"chart_line.png"];

    MGMEventsViewController* eventsViewController = [[MGMEventsViewController alloc] init];
    eventsViewController.ui = self.ui;
    eventsViewController.title = @"Previous Events";
    eventsViewController.albumSelectionDelegate = self.ui;
    eventsViewController.playlistSelectionDelegate = self.ui;
    eventsViewController.tabBarItem.title = @"Previous Events";
    eventsViewController.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];

    MGMAlbumScoresViewController* albumScoresViewController = [[MGMAlbumScoresViewController alloc] init];
    albumScoresViewController.ui = self.ui;
    albumScoresViewController.title = @"Album Scores";
    albumScoresViewController.albumSelectionDelegate = self.ui;
    albumScoresViewController.tabBarItem.title = @"Album Scores";
    albumScoresViewController.tabBarItem.image = [UIImage imageNamed:@"ruler.png"];

    [self setViewControllers: @[eventsViewController, weeklyChartViewController, albumScoresViewController]];

    self.selectedViewController = eventsViewController;
    [self tabBarController:self didSelectViewController:eventsViewController];
}

#pragma mark -
#pragma mark MGMBackgroundAlbumArtFetcherDelegate

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher renderImage:(UIImage*)image atIndex:(NSUInteger)index
{
    [self renderBackgroundAlbumImage:image atIndex:index animation:YES];
}

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher errorOccured:(NSError*)error atIndex:(NSUInteger)index
{
    [self.ui logError:error];
    [self artFetcher:fetcher renderImage:nil atIndex:index];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(assignBackgroundView:)])
    {
        MGMTabbedViewController* tabbedController = (MGMTabbedViewController*)viewController;
        [self.albumsView removeFromSuperview];
        [tabbedController assignBackgroundView:self.albumsView];
    }
}

@end
