
//
//  MGMHomeViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeViewController.h"

#import "MGMBackgroundAlbumArtFetcher.h"
#import "MGMEvent.h"
#import "MGMPulsatingAlbumsView.h"
#import "NSMutableArray+Shuffling.h"

@interface MGMHomeViewController () <MGMBackgroundAlbumArtFetcherDelegate>

@property (strong) IBOutlet MGMPulsatingAlbumsView* albumsView;
@property (strong) IBOutlet UILabel* nextEventDateLabel;

@property (strong) MGMBackgroundAlbumArtFetcher* artFetcher;
@property (strong) NSManagedObjectID* eventMoid;

- (IBAction) previousEventsPressed:(id)sender;
- (IBAction) chartsPressed:(id)sender;

@end

#define NEXT_EVENT_PATTERN @"The next event will be on %@ at %@"

@implementation MGMHomeViewController

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.albumsView setupAlbumsInRow:4];

    for (NSUInteger i = 0; i < self.albumsView.albumCount; i++)
    {
        NSUInteger index = (i % 3) + 1;
        NSString* imageName = [NSString stringWithFormat:@"album%d.png", index];
        UIImage* image = [UIImage imageNamed:imageName];
        [self.albumsView renderImage:image atIndex:i animation:NO];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadImages];

    if (self.eventMoid == nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            [self.core.daoFactory.eventsDao fetchAllEvents:^(NSArray* fetchedEvents, NSError* fetchError)
            {
                if (fetchError && fetchedEvents)
                {
                    [self logError:fetchError];
                }

                if (fetchedEvents.count > 0)
                {
                    MGMEvent* event = [fetchedEvents objectAtIndex:0];
                    self.eventMoid = event.objectID;
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        [self displayEventWithMoid:self.eventMoid];
                    });
                }
                else
                {
                    [self showError:fetchError];
                }
            }];
        });
    }
}

- (void) displayEventWithMoid:(NSManagedObjectID*)eventMoid
{
    MGMEvent* event = [self.core.daoFactory.coreDataDao threadVersion:eventMoid];
    [self displayEvent:event];
}

- (void) displayEvent:(MGMEvent*)event
{
    [super displayEvent:event];
    
    if (event.eventDate)
    {
        NSDateFormatter* eventDateFormatter = [[NSDateFormatter alloc] init];

        [eventDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [eventDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString* dateString = [eventDateFormatter stringFromDate:event.eventDate];

        [eventDateFormatter setDateStyle:NSDateFormatterNoStyle];
        [eventDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString* timeString = [eventDateFormatter stringFromDate:event.eventDate];

        self.nextEventDateLabel.text = [NSString stringWithFormat:NEXT_EVENT_PATTERN, dateString, timeString];
    }    
}

- (void) loadImages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        if (self.artFetcher == nil)
        {
            // Search in a background thread...
            [self.core.daoFactory.lastFmDao fetchAllTimePeriods:^(NSArray* fetchedTimePeriods, NSError* timePeriodFetchError)
            {
                if (timePeriodFetchError && fetchedTimePeriods)
                {
                    [self logError:timePeriodFetchError];
                }

                if (fetchedTimePeriods.count > 0)
                {
                    MGMTimePeriod* fetchedTimePeriod = [fetchedTimePeriods objectAtIndex:0];
                    [self.core.daoFactory.lastFmDao fetchWeeklyChartForStartDate:fetchedTimePeriod.startDate endDate:fetchedTimePeriod.endDate completion:^(MGMWeeklyChart* fetchedWeeklyChart, NSError* weeklyChartFetchError)
                    {
                        if (weeklyChartFetchError && fetchedWeeklyChart)
                        {
                            [self logError:weeklyChartFetchError];
                        }

                        if (fetchedWeeklyChart)
                        {
                            self.artFetcher = [[MGMBackgroundAlbumArtFetcher alloc] initWithChartEntryMoids:[self chartEntryMoidsForWeeklyChart:fetchedWeeklyChart]];
                            self.artFetcher.daoFactory = self.core.daoFactory;
                            self.artFetcher.delegate = self;
                            [self renderImages:YES];
                        }
                        else
                        {
                            [self showError:weeklyChartFetchError];
                        }
                    }];
                }
                else
                {
                    [self showError:timePeriodFetchError];
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
    NSArray* shuffledIndicies = [self shuffledIndicies:self.albumsView.albumCount];
    NSTimeInterval sleepTime = initialRender ? 0.05 : 1.0;
    for (NSUInteger i = 0; i < self.albumsView.albumCount; i++)
    {
        NSNumber* index = [shuffledIndicies objectAtIndex:i];
        [self.artFetcher generateImageAtIndex:[index integerValue]];
        [NSThread sleepForTimeInterval:sleepTime];
    }
}

- (NSArray*) shuffledIndicies:(NSUInteger)size
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < self.albumsView.albumCount; i++)
    {
        [array addObject:[NSNumber numberWithInteger:i]];
    }
    [array shuffle];
    return [array copy];
}

- (IBAction) previousEventsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionPreviousEvents];
}

- (IBAction) chartsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionCharts];
}

#pragma mark -
#pragma mark MGMBackgroundAlbumArtFetcherDelegate

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher renderImage:(UIImage*)image atIndex:(NSUInteger)index
{
    if (image == nil)
    {
        image = [UIImage imageNamed:@"album1.png"];
    }

    [self.albumsView renderImage:image atIndex:index animation:YES];
}

- (void) artFetcher:(MGMBackgroundAlbumArtFetcher*)fetcher errorOccured:(NSError*)error
{
    [self logError:error];
}

@end
