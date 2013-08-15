//
//  MGMLastFmDao.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 05/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMLastFmDao.h"
#import "MGMChartEntry.h"

#define WEEKLY_PERIODS_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyChartList&group=%@&api_key=%@&format=json"
#define GROUP_ALBUM_CHART_URL @"http://ws.audioscrobbler.com/2.0/?method=group.getWeeklyAlbumChart&group=%@&from=%d&to=%d&api_key=%@&format=json"
#define ALBUM_INFO_URL @"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=%@&mbid=%@&format=json"

#define GROUP_NAME @"Music+Geek+Monthly"
#define API_KEY @"a854bc0fca8c0d316751ed4ed2082379"

#define MAX_TIME_PERIODS 104

#define IMAGE_SIZE_SMALL @"small"
#define IMAGE_SIZE_MEDIUM @"medium"
#define IMAGE_SIZE_LARGE @"large"
#define IMAGE_SIZE_EXTRA_LARGE @"extralarge"
#define IMAGE_SIZE_MEGA @"mega"

@interface MGMLastFmDao ()

@property (strong) NSArray* sizeStrings;
@property (strong) NSNumberFormatter* numberFormatter;

@end

@implementation MGMLastFmDao

- (id) init
{
    if (self = [super init])
    {
        self.sizeStrings = @[IMAGE_SIZE_SMALL, IMAGE_SIZE_MEDIUM, IMAGE_SIZE_LARGE, IMAGE_SIZE_EXTRA_LARGE, IMAGE_SIZE_MEGA];
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    }
    return self;
}

- (NSArray*) weeklyTimePeriods:(NSError**)error
{
    NSString* urlString = [NSString stringWithFormat:WEEKLY_PERIODS_URL, GROUP_NAME, API_KEY];
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
        if (error && *error != nil)
        {
            return nil;
        }
        return [self timePeriodsForJson:json error:error];
    }
    return nil;
}

- (MGMTimePeriod*) mostRecentTimePeriod:(NSError**)error
{
    return [[self weeklyTimePeriods:error] objectAtIndex:0];
}

- (MGMWeeklyChart*) topWeeklyAlbumsForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate error:(NSError**)error
{
    MGMWeeklyChart* chart = [self.coreDataDao fetchWeeklyChart:startDate endDate:endDate error:error];
    if (error && *error != nil)
    {
        return nil;
    }
    
    if (chart == nil)
    {
        NSUInteger from = startDate.timeIntervalSince1970;
        NSUInteger to = endDate.timeIntervalSince1970;
        NSString* urlString = [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, from, to, API_KEY];
        NSData* jsonData = [self contentsOfUrl:urlString];
        if (jsonData)
        {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
            if (error && *error != nil)
            {
                return nil;
            }

            chart = [self.coreDataDao createNewWeeklyChart:error];
            if (error && *error != nil)
            {
                return nil;
            }

            chart.startDate = startDate;
            chart.endDate = endDate;
            [self addAlbumsToChart:chart forJson:json error:error];
            if (error && *error != nil)
            {
                return nil;
            }

            [self.coreDataDao persistChanges:error];
            if (error && *error != nil)
            {
                return nil;
            }

            return chart;
        }
        return nil;
    }
    else
    {
        return chart;
    }
}

- (void) updateAlbumInfo:(MGMAlbum*)album error:(NSError**)error
{
    NSString* urlString = [NSString stringWithFormat:ALBUM_INFO_URL, API_KEY, album.albumMbid];
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
        if (error && *error != nil)
        {
            return;
        }
        [self updateAlbumInfo:album withJson:json error:error];
    }
}

- (NSArray*) timePeriodsForJson:(NSDictionary*)json error:(NSError**)error
{
    NSDictionary* weeklychartlist = [json objectForKey:@"weeklychartlist"];
    NSArray* chart = [weeklychartlist objectForKey:@"chart"];
    NSArray* reversedChart = [self reverseArray:chart];
    NSUInteger cap = reversedChart.count < MAX_TIME_PERIODS ? reversedChart.count : MAX_TIME_PERIODS;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:cap];
    for (NSUInteger i = 0; i < cap; i++)
    {
        NSDictionary* period = [reversedChart objectAtIndex:i];
        NSUInteger from = [[period objectForKey:@"from"] intValue];
        NSUInteger to = [[period objectForKey:@"to"] intValue];
        NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:from];
        NSDate* toDate = [NSDate dateWithTimeIntervalSince1970:to];
        MGMTimePeriod* timePeriod = [self.coreDataDao fetchTimePeriod:fromDate endDate:toDate error:error];
        if (error && *error != nil)
        {
            return nil;
        }

        if (!timePeriod)
        {
            timePeriod = [self.coreDataDao createNewTimePeriod:error];
            if (error && *error != nil)
            {
                return nil;
            }
            
            timePeriod.startDate = fromDate;
            timePeriod.endDate = toDate;
            [self.coreDataDao persistChanges:error];
            if (error && *error != nil)
            {
                return nil;
            }

        }
        [results addObject:timePeriod];
    }

    return [results copy];
}

- (NSArray *)reverseArray:(NSArray*)array
{
    NSMutableArray* reversed = [NSMutableArray arrayWithCapacity:array.count];
    NSEnumerator* enumerator = array.reverseObjectEnumerator;
    for (id element in enumerator)
    {
        [reversed addObject:element];
    }
    return [reversed copy];
}

- (void) addAlbumsToChart:(MGMWeeklyChart*)chart forJson:(NSDictionary*)json error:(NSError**)error
{
    NSDictionary* weeklyalbumchart = [json objectForKey:@"weeklyalbumchart"];
    NSArray* albums = [weeklyalbumchart objectForKey:@"album"];
    for (NSDictionary* album in albums)
    {
        MGMChartEntry* converted = [self albumForJson:album error:error];
        [chart addChartEntriesObject:converted];
        [self.coreDataDao persistChanges:error];
        if (error && *error != nil)
        {
            return;
        }
    }
}

- (MGMChartEntry*) albumForJson:(NSDictionary*)json error:(NSError**)error
{
    MGMChartEntry* chartEntry = [self.coreDataDao createNewChartEntry:error];
    if (error && *error != nil)
    {
        return nil;
    }

    NSString* listeners = [json objectForKey:@"playcount"];
    NSString* rank = [[json objectForKey:@"@attr"] objectForKey:@"rank"];
    chartEntry.rank = [self.numberFormatter numberFromString:rank];
    chartEntry.listeners = [self.numberFormatter numberFromString:listeners];

    NSString* albumMbid = [json objectForKey:@"mbid"];
    MGMAlbum* album = [self.coreDataDao fetchAlbum:albumMbid error:error];
    if (error && *error != nil)
    {
        return nil;
    }

    if (album == nil)
    {
        album = [self.coreDataDao createNewAlbum:error];
        if (error && *error != nil)
        {
            return nil;
        }

        NSDictionary* artist = [json objectForKey:@"artist"];
        NSString* artistName = [artist objectForKey:@"#text"];
        NSString* albumName = [json objectForKey:@"name"];
        album.artistName = artistName;
        album.albumMbid = albumMbid;
        album.albumName = albumName;
    }

    chartEntry.album = album;
    
    [self.coreDataDao persistChanges:error];
    if (error && *error != nil)
    {
        return nil;
    }

    return chartEntry;
}

- (void) updateAlbumInfo:(MGMAlbum*)album withJson:(NSDictionary*)json error:(NSError**)error
{
    NSDictionary* albumJson = [json objectForKey:@"album"];
    NSArray* images = [albumJson objectForKey:@"image"];
    for (NSDictionary* image in images)
    {
        NSString* key = [image objectForKey:@"size"];
        NSString* value = [image objectForKey:@"#text"];
        if (value && value.length > 0)
        {
            MGMAlbumImageSize size = [self.sizeStrings indexOfObject:key];
            if (size != NSNotFound)
            {
                MGMAlbumImageUri* uri = [self.coreDataDao fetchAlbumImageUriForAlbum:album size:size error:error];
                if (error && *error != nil)
                {
                    return;
                }

                if (uri == nil)
                {
                    uri = [self.coreDataDao createNewAlbumImageUri:error];
                    if (error && *error != nil)
                    {
                        return;
                    }

                    uri.size = size;
                    uri.uri = value;
                    [album addImageUrisObject:uri];
                    [self.coreDataDao persistChanges:error];

                    if (error && *error != nil)
                    {
                        return;
                    }
                }
            }
        }
    }
}

@end
