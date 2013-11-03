
//
//  MGMHomeViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeViewController.h"

#import "CKCalendarView.h"
#import "MGMBackgroundAlbumArtFetcher.h"
#import "MGMEvent.h"
#import "MGMPulsatingAlbumsView.h"
#import "NSMutableArray+Shuffling.h"

@interface MGMHomeViewController () <MGMBackgroundAlbumArtFetcherDelegate, CKCalendarDelegate>

@property (strong) IBOutlet MGMPulsatingAlbumsView* albumsView;
@property (strong) IBOutlet CKCalendarView* calendarView;

@property (strong) MGMBackgroundAlbumArtFetcher* artFetcher;
@property (strong) NSManagedObjectID* eventMoid;

@end

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

    BOOL iPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    CGFloat titleFontSize = iPad ? 20.0 : 14.0;
    CGFloat dayFontSize = iPad ? 13.0 : 9.0;
    CGFloat dateFontSize = iPad ? 18.0 : 13.0;

    self.calendarView.hidden = YES;
    self.calendarView.delegate = self;
    self.calendarView.titleFont = [UIFont boldSystemFontOfSize:titleFontSize];
    self.calendarView.dayOfWeekFont = [UIFont boldSystemFontOfSize:dayFontSize];
    self.calendarView.dateFont = [UIFont boldSystemFontOfSize:dateFontSize];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadImages];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        [self.core.daoFactory.eventsDao fetchAllEvents:^(NSArray* fetchedEvents, NSError* fetchError) {
            if (fetchError && fetchedEvents.count > 0)
            {
                [self logError:fetchError];
            }

            if (fetchedEvents.count > 0) {
                MGMEvent* event = [fetchedEvents objectAtIndex:0];
                self.eventMoid = event.objectID;
                dispatch_async(dispatch_get_main_queue(), ^ {
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
        self.calendarView.hidden = NO;
        [self.calendarView selectDate:event.eventDate makeVisible:YES];
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

#pragma mark -
#pragma mark CKCalendarDelegate

- (BOOL)calendar:(CKCalendarView*)calendar willSelectDate:(NSDate*)date
{
    return NO;
}

- (BOOL)calendar:(CKCalendarView*)calendar willDeselectDate:(NSDate*)date
{
    return NO;
}

- (BOOL)calendar:(CKCalendarView*)calendar willChangeToMonth:(NSDate*)date
{
    return NO;
}

@end
