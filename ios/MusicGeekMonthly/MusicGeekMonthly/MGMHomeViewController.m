
//
//  MGMHomeViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeViewController.h"
#import "MGMPulsatingAlbumsView.h"
#import "MGMEvent.h"

@interface MGMHomeViewController ()

@property (strong) IBOutlet MGMPulsatingAlbumsView* albumsView;
@property (strong) IBOutlet UILabel* nextEventDateLabel;

@property (strong) MGMEvent* event;
@property (strong) NSArray* backgroundChartEntries;
@property (strong) NSArray* backgroundChartEntryViewIndices;
@property NSUInteger backgroundChartEntryIndex;

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

    [self.core.daoFactory.eventsDao fetchLatestEvent:^(MGMEvent* fetchedEvent, NSError* fetchError)
    {
        self.event = fetchedEvent;
        if (fetchError)
        {
            [self handleError:fetchError];
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self displayEvent:self.event];
        });
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadImages];
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
    NSUInteger albumsToRender = self.albumsView.albumCount;
    if (self.backgroundChartEntries == nil)
    {
        [self.core.daoFactory.lastFmDao fetchLatestTimePeriod:^(MGMTimePeriod* fetchedTimePeriod, NSError* timePeriodFetchError)
        {
            if (timePeriodFetchError)
            {
                [self handleError:timePeriodFetchError];
                return;
            }

            [self.core.daoFactory.lastFmDao fetchWeeklyChartForStartDate:fetchedTimePeriod.startDate endDate:fetchedTimePeriod.endDate completion:^(MGMWeeklyChart* fetchedWeeklyChart, NSError* weeklyChartFetchError)
            {
                self.backgroundChartEntries = [self shuffledArray:fetchedWeeklyChart.chartEntries];
                if (weeklyChartFetchError)
                {
                    [self handleError:weeklyChartFetchError];
                    return;
                }

                NSMutableOrderedSet* indices = [NSMutableOrderedSet orderedSetWithCapacity:albumsToRender];
                for (NSUInteger i = 0; i < albumsToRender; i++)
                {
                    [indices addObject:[NSNumber numberWithInt:i]];
                }
                self.backgroundChartEntryViewIndices = [self shuffledArray:indices];
                self.backgroundChartEntryIndex = 0;
                [self renderImages];
            }];
        }];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            // Search in a background thread...
            [self renderImages];
        });
    }
}

- (void) renderImages
{
    for (NSNumber* albumViewIndex in self.backgroundChartEntryViewIndices)
    {
        [self nextBackgroundAlbumArtUri:^(NSString* uri, NSError* fetchError)
        {
            if (fetchError)
            {
                [self handleError:fetchError];
                return;
            }

            UIImage* image = nil;
            if (uri)
            {
                NSError* error = nil;
                image = [MGMImageHelper imageFromUrl:uri error:&error];
                if (error)
                {
                    [self handleError:error];
                }
            }
            if (image == nil)
            {
                image = [UIImage imageNamed:@"album1.png"];
            }
            dispatch_async(dispatch_get_main_queue(), ^
            {
                // ... but update the UI in the main thread...
                [self.albumsView renderImage:image atIndex:albumViewIndex.intValue];
            });
        }];
        // Sleep for a bit to give a tiling effect...
        [NSThread sleepForTimeInterval:0.25];
    }
}

- (void) nextBackgroundAlbumArtUri:(FETCH_COMPLETION)completion
{
    void (^processingBlock)(NSUInteger);
    
    void (^resultBlock)(MGMAlbum*, NSError*, NSUInteger) = ^(MGMAlbum* album, NSError* error, NSUInteger iterations)
    {
        if (error)
        {
            completion(nil, error);
        }
        else
        {
            if (self.backgroundChartEntryIndex == self.backgroundChartEntries.count)
            {
                self.backgroundChartEntryIndex = 0;
            }

            NSString* uri = [album bestAlbumImageUrl];
            if (uri == nil && iterations < 10)
            {
                processingBlock(iterations + 1);
            }
            else
            {
                completion(uri, nil);
            }
        }
    };

    processingBlock = ^(NSUInteger iterations)
    {
        MGMChartEntry* chartEntry = [self.backgroundChartEntries objectAtIndex:self.backgroundChartEntryIndex++];
        MGMAlbum* album = chartEntry.album;
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album completion:^(MGMAlbum* updatedAlbum, NSError* updateError)
            {
                resultBlock(updatedAlbum, updateError, iterations);
            }];
        }
        else
        {
            resultBlock(album, nil, iterations);
        }
    };
}

- (NSArray*) shuffledArray:(NSOrderedSet*)input
{
    NSMutableArray* copy = [[input array] mutableCopy];
    for (int i = [input count] - 1; i > 0; i--)
    {
        int j = arc4random() % (i + 1);
        [copy exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    return [copy copy];
}

- (IBAction) previousEventsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionPreviousEvents];
}

- (IBAction) chartsPressed:(id)sender
{
    [self.delegate optionSelected:MGMHomeViewControllerOptionCharts];
}

@end
