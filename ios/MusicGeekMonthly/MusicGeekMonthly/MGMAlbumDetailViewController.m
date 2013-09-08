//
//  MGMAlbumDetailViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 25/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailViewController.h"

#import "MGMAlbum.h"
#import "MGMAlbumView.h"
#import "MGMAlbumViewUtilities.h"

#define CELL_ID @"ALBUM_DETAIL_CELL_ID"

@interface MGMKeyValuePair : NSObject

@property MGMAlbumServiceType serviceType;
@property (strong) NSString* displayString;

@end

@implementation MGMKeyValuePair

@end

@interface MGMAlbumDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong) IBOutlet MGMAlbumView* albumView;
@property (strong) IBOutlet UITableView* tableView;

@property (strong) NSManagedObjectID* albumMoid;
@property (strong) NSArray* keyValuePairs;

@end

@implementation MGMAlbumDetailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    MGMAlbum* album = [self.core.daoFactory.coreDataDao threadVersion:self.albumMoid];
    NSError* error = nil;
    [MGMAlbumViewUtilities displayAlbum:album inAlbumView:self.albumView defaultImageName:@"album2.png" daoFactory:self.core.daoFactory error:&error];
    if (error)
    {
        [self logError:error];
    }

    [self.tableView reloadData];
}

- (void) transitionCompleteWithState:(id)state
{
    MGMAlbum* album = state;
    self.albumMoid = album.objectID;
    self.keyValuePairs = [self optionsForAlbum:album];
}

- (NSArray*) optionsForAlbum:(MGMAlbum*)album
{
    NSMutableArray* array = [NSMutableArray array];
    for (MGMAlbumMetadata* metadata in album.metadata)
    {
        NSString* displayString = [self stringForServiceType:metadata.serviceType album:album];
        if (displayString)
        {
            MGMKeyValuePair* pair = [[MGMKeyValuePair alloc] init];
            pair.serviceType = metadata.serviceType;
            pair.displayString = displayString;
            [array addObject:pair];
        }
    }
    NSArray* sorted = [array sortedArrayUsingComparator:^NSComparisonResult(MGMKeyValuePair* a, MGMKeyValuePair* b)
    {
        NSNumber* first = [NSNumber numberWithInteger:a.serviceType];
        NSNumber* second = [NSNumber numberWithInteger:b.serviceType];
        return [first compare:second];
    }];
    return sorted;
}

- (NSString*) stringForServiceType:(MGMAlbumServiceType)serviceType album:(MGMAlbum*)album
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeLastFm:
            return [NSString stringWithFormat:@"Play %@ radio with Last.fm", album.artistName];
        case MGMAlbumServiceTypeSpotify:
            return @"Play with Spotify";
        case MGMAlbumServiceTypeWikipedia:
            return @"Read Wikipedia article";
        case MGMAlbumServiceTypeYouTube:
            return @"Play with YouTube";
        case MGMAlbumServiceTypeItunes:
            return @"Open with iTunes";
        default:
            return nil;
    }
}

- (IBAction) cancelPressed:(id)sender
{
    [self.ui albumDetailDismissed];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keyValuePairs.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }

    MGMKeyValuePair* pair = [self.keyValuePairs objectAtIndex:indexPath.row];
    cell.textLabel.text = pair.displayString;
    cell.imageView.image = [self imageForServiceType:pair.serviceType];

    return cell;
}

- (UIImage*) imageForServiceType:(MGMAlbumServiceType)serviceType
{
    switch (serviceType)
    {
        case MGMAlbumServiceTypeLastFm:
            return [UIImage imageNamed:@"lastfm.png"];
        case MGMAlbumServiceTypeSpotify:
            return [UIImage imageNamed:@"spotify.png"];
        case MGMAlbumServiceTypeWikipedia:
            return [UIImage imageNamed:@"wikipedia.png"];
        case MGMAlbumServiceTypeYouTube:
            return [UIImage imageNamed:@"youtube.png"];
        case MGMAlbumServiceTypeItunes:
            return [UIImage imageNamed:@"itunes.png"];
        default:
            return nil;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MGMKeyValuePair* pair = [self.keyValuePairs objectAtIndex:indexPath.row];
    MGMAlbum* album = [self.core.daoFactory.coreDataDao threadVersion:self.albumMoid];
    [self.ui.albumPlayer playAlbum:album onService:pair.serviceType completion:^(NSError* error)
    {
        if (error)
        {
            [self showError:error];
        }
    }];
    [self cancelPressed:nil];
}

@end
