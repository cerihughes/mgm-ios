//
//  MGMNavigationViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMNavigationViewController.h"

#import "MGMAlbumScoresViewController.h"
#import "MGMAlbumViewUtilities.h"
#import "MGMBackgroundAlbumArtFetcher.h"
#import "MGMEventsViewController.h"
#import "MGMHomeViewController.h"
#import "MGMPulsatingAlbumsView.h"
#import "MGMTabbedViewController.h"
#import "MGMWeeklyChartViewController.h"
#import "NSMutableArray+Shuffling.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMNavigationViewController () <MGMBackgroundAlbumArtFetcherDelegate, UITabBarControllerDelegate>

@property (strong) MGMPulsatingAlbumsView* albumsView;

@property (weak) MGMUI* ui;
@property NSUInteger backgroundAlbumCount;
@property (strong) MGMBackgroundAlbumArtFetcher* artFetcher;

@end

@implementation MGMNavigationViewController

- (id) initWithUI:(MGMUI*)ui
{
    if (self = [super init])
    {
        self.delegate = self;
        self.ui = ui;
        [self createControllers];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.albumsView = [[MGMPulsatingAlbumsView alloc] initWithFrame:self.view.frame];

    self.backgroundAlbumCount = [self setBackgroundAlbumsInRow:4];

    for (NSUInteger i = 0; i < self.backgroundAlbumCount; i++)
    {
        NSUInteger index = (i % 3) + 1;
        NSString* imageName = [NSString stringWithFormat:@"album%lu.png", (unsigned long)index];
        UIImage* image = [UIImage imageNamed:imageName];
        [self renderBackgroundAlbumImage:image atIndex:i animation:NO];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadImages];
}

- (NSUInteger) setBackgroundAlbumsInRow:(NSUInteger)albumsInRow
{
    [self.albumsView setupAlbumsInRow:4];
    return self.albumsView.albumCount;
}

- (void) renderBackgroundAlbumImage:(UIImage *)image atIndex:(NSUInteger)index animation:(BOOL)animation
{
    [self.albumsView renderImage:image atIndex:index animation:YES];
}

- (void) createControllers
{
    MGMHomeViewController* homeViewController = [[MGMHomeViewController alloc] init];
    homeViewController.ui = self.ui;
    homeViewController.title = @"Home";
    homeViewController.albumSelectionDelegate = self.ui;
    homeViewController.tabBarItem.title = @"Home";
    homeViewController.tabBarItem.image = [UIImage imageNamed:@"home.png"];

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
    eventsViewController.tabBarItem.title = @"Previous Events";
    eventsViewController.tabBarItem.image = [UIImage imageNamed:@"calendar.png"];

    MGMAlbumScoresViewController* albumScoresViewController = [[MGMAlbumScoresViewController alloc] init];
    albumScoresViewController.ui = self.ui;
    albumScoresViewController.title = @"Album Scores";
    albumScoresViewController.albumSelectionDelegate = self.ui;
    albumScoresViewController.tabBarItem.title = @"Album Scores";
    albumScoresViewController.tabBarItem.image = [UIImage imageNamed:@"ruler.png"];

    [self setViewControllers: @[homeViewController, weeklyChartViewController, eventsViewController, albumScoresViewController]];

    self.selectedViewController = homeViewController;
    [self tabBarController:self didSelectViewController:homeViewController];
}

- (void) loadImages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        if (self.artFetcher == nil)
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao fetchAllTimePeriods:^(NSArray* fetchedTimePeriods, NSError* timePeriodFetchError) {
                if (timePeriodFetchError && fetchedTimePeriods)
                {
                    [self.ui logError:timePeriodFetchError];
                }

                if (fetchedTimePeriods.count > 0)
                {
                    MGMTimePeriod* fetchedTimePeriod = [fetchedTimePeriods objectAtIndex:0];
                    [self.core.daoFactory.lastFmDao fetchWeeklyChartForStartDate:fetchedTimePeriod.startDate endDate:fetchedTimePeriod.endDate completion:^(MGMWeeklyChart* fetchedWeeklyChart, NSError* weeklyChartFetchError) {
                        if (weeklyChartFetchError && fetchedWeeklyChart)
                        {
                            [self.ui logError:weeklyChartFetchError];
                        }

                        if (fetchedWeeklyChart)
                        {
                            self.artFetcher = [[MGMBackgroundAlbumArtFetcher alloc] initWithChartEntryMoids:[self chartEntryMoidsForWeeklyChart:fetchedWeeklyChart]];
                            self.artFetcher.daoFactory = self.core.daoFactory;
                            self.artFetcher.delegate = self;
                            CGSize size = [self.albumsView albumSize];
                            MGMAlbumImageSize preferredSize = [MGMAlbumViewUtilities preferredImageSizeForViewSize:size];
                            self.artFetcher.preferredSize = preferredSize;
                            [self renderImages:YES];
                        }
                        else
                        {
                            [self.ui showError:weeklyChartFetchError];
                        }
                    }];
                }
                else
                {
                    [self.ui showError:timePeriodFetchError];
                }
            }];
        }
        else
        {
            [self renderImages:NO];
        }
    });
}

- (NSArray*) chartEntryMoidsForWeeklyChart:(MGMWeeklyChart*)weeklyChart
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:weeklyChart.chartEntries.count];
    for (MGMChartEntry* entry in weeklyChart.chartEntries)
    {
        [array addObject:entry.objectID];
    }
    return [array copy];
}

- (void) renderImages:(BOOL)initialRender
{
    NSArray* shuffledIndicies = [self shuffledIndicies:self.backgroundAlbumCount];
    NSTimeInterval sleepTime = initialRender ? 0.05 : 1.0;
    for (NSUInteger i = 0; i < self.backgroundAlbumCount; i++)
    {
        NSNumber* index = [shuffledIndicies objectAtIndex:i];
        [self.artFetcher generateImageAtIndex:[index integerValue]];
        [NSThread sleepForTimeInterval:sleepTime];
    }
}

- (NSArray*) shuffledIndicies:(NSUInteger)size
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < self.backgroundAlbumCount; i++)
    {
        [array addObject:[NSNumber numberWithInteger:i]];
    }
    [array shuffle];
    return [array copy];
}

#pragma mark -
#pragma mark MGMBackgroundAlbumArtFetcherDelegate

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher renderImage:(UIImage*)image atIndex:(NSUInteger)index
{
    if (image == nil)
    {
        image = [UIImage imageNamed:@"album1.png"];
    }

    [self renderBackgroundAlbumImage:image atIndex:index animation:YES];

    if (index == self.backgroundAlbumCount - 1)
    {
        double delayInSeconds = self.backgroundAlbumCount * 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadImages];
        });
    }
}

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher errorOccured:(NSError*)error
{
    [self.ui logError:error];
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
