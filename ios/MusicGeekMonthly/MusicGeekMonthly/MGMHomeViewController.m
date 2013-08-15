
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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        NSError* error = nil;
        self.event = [self.core.daoFactory.eventsDao latestEvent:&error];
        if (error)
        {
            [self handleError:error];
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^
        {
            // ... but update the UI in the main thread...
            [self displayEvent:self.event];
        });
    });

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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // Search in a background thread...
        NSUInteger albumsToRender = self.albumsView.albumCount;
        if (self.backgroundChartEntries == nil)
        {
            NSError* error = nil;
            MGMTimePeriod* mostRecent = [self.core.daoFactory.lastFmDao mostRecentTimePeriod:&error];
            if (error)
            {
                [self handleError:error];
                return;
            }

            self.backgroundChartEntries = [self shuffledArray:[self.core.daoFactory.lastFmDao topWeeklyAlbumsForStartDate:mostRecent.startDate endDate:mostRecent.endDate error:&error].chartEntries];
            if (error)
            {
                [self handleError:error];
                return;
            }

            NSMutableOrderedSet* indices = [NSMutableOrderedSet orderedSetWithCapacity:albumsToRender];
            for (NSUInteger i = 0; i < albumsToRender; i++)
            {
                [indices addObject:[NSNumber numberWithInt:i]];
            }
            self.backgroundChartEntryViewIndices = [self shuffledArray:indices];
            self.backgroundChartEntryIndex = 0;
        }

        for (NSNumber* albumViewIndex in self.backgroundChartEntryViewIndices)
        {
            NSString* albumArtUri = [self nextBackgroundAlbumArtUri];
            if (albumArtUri)
            {
                NSError* error = nil;
                UIImage* image = [MGMImageHelper imageFromUrl:albumArtUri error:&error];
                if (error)
                {
                    [self handleError:error];
                    return;
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
                // Sleep for a bit to give a tiling effect...
                [NSThread sleepForTimeInterval:0.25];
            }
        }

    });
}

- (NSString*) nextBackgroundAlbumArtUri
{
    NSUInteger howManyChecks = 0;
    NSString* uri = nil;
    while (howManyChecks < self.backgroundChartEntries.count && uri == nil)
    {
        MGMChartEntry* chartEntry = [self.backgroundChartEntries objectAtIndex:self.backgroundChartEntryIndex++];
        MGMAlbum* album = chartEntry.album;
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            NSError* error = nil;
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album error:&error];
            if (error != nil)
            {
                [self handleError:error];
            }
        }

        if (self.backgroundChartEntryIndex == self.backgroundChartEntries.count)
        {
            self.backgroundChartEntryIndex = 0;
        }
        uri = [album bestAlbumImageUrl];
    }
    return uri;
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
