
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
@property (strong) NSArray* backgroundAlbums;
@property (strong) NSArray* backgroundAlbumViewIndices;
@property NSUInteger backgroundAlbumIndex;

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
        self.event = [self.core.daoFactory.eventsDao latestEvent];

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
        if (self.backgroundAlbums == nil)
        {
            NSUInteger albumContentPoolSize = albumsToRender * 2;
            self.backgroundAlbums = [self shuffledArray:[self.core.daoFactory.lastFmDao topWeeklyAlbumsForMostRecentTimePeriod:albumContentPoolSize].albums];

            NSMutableOrderedSet* indices = [NSMutableOrderedSet orderedSetWithCapacity:albumsToRender];
            for (NSUInteger i = 0; i < albumsToRender; i++)
            {
                [indices addObject:[NSNumber numberWithInt:i]];
            }
            self.backgroundAlbumViewIndices = [self shuffledArray:indices];
            self.backgroundAlbumIndex = 0;
        }

        for (NSNumber* albumViewIndex in self.backgroundAlbumViewIndices)
        {
            NSString* albumArtUri = [self nextBackgroundAlbumArtUri];
            if (albumArtUri)
            {
                UIImage* image = [MGMImageHelper imageFromUrl:albumArtUri];
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
    while (howManyChecks < self.backgroundAlbums.count && uri == nil)
    {
        MGMAlbum* album = [self.backgroundAlbums objectAtIndex:self.backgroundAlbumIndex++];
        if ([album searchedServiceType:MGMAlbumServiceTypeLastFm] == NO)
        {
            [self.core.daoFactory.lastFmDao updateAlbumInfo:album];
        }

        if (self.backgroundAlbumIndex == self.backgroundAlbums.count)
        {
            self.backgroundAlbumIndex = 0;
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
