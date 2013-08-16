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

- (void) weeklyTimePeriods:(FETCH_MANY_COMPLETION)completion
{
    NSArray* array = nil;
    NSError* error = nil;

    NSString* urlString = [NSString stringWithFormat:WEEKLY_PERIODS_URL, GROUP_NAME, API_KEY];
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (jsonData)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            array = [self timePeriodsForJson:json error:&error];
        }
    }
    
    completion(array, error);
}

- (void) mostRecentTimePeriod:(FETCH_COMPLETION)completion
{
    [self weeklyTimePeriods:^(NSArray* array, NSError* error)
    {
        if (array.count > 0)
        {
            completion([array objectAtIndex:0], error);
        }
    }];
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

- (void) topWeeklyAlbumsForStartDate:(NSDate*)startDate endDate:(NSDate*)endDate completion:(FETCH_COMPLETION)completion;
{
    [self.coreDataDao fetchWeeklyChart:startDate endDate:endDate completion:^(NSManagedObject* chart, NSError* error)
    {
        if (error != nil)
        {
            completion(nil, error);
            return;
        }
        if (chart == nil)
        {
            NSUInteger from = startDate.timeIntervalSince1970;
            NSUInteger to = endDate.timeIntervalSince1970;
            NSString* urlString = [NSString stringWithFormat:GROUP_ALBUM_CHART_URL, GROUP_NAME, from, to, API_KEY];
            NSData* jsonData = [self contentsOfUrl:urlString];
            if (jsonData)
            {
                NSError* jsonError = nil;
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
                if (jsonError == nil)
                {
                    [self.coreDataDao createNewWeeklyChartForStartDate:startDate endDate:endDate completion:^(MGMWeeklyChart* newChart, NSError* creationError)
                    {
                        if (creationError == nil)
                        {
                            [self addAlbumsToChart:chart forJson:json error:error];
                        }
                    }];
                }


                return chart;
            }
            return nil;
        }
        else
        {
            return chart;
        }
    }];
}

- (void) updateAlbumInfo:(MGMAlbum*)album completion:(VOID_COMPLETION)completion
{
    NSString* urlString = [NSString stringWithFormat:ALBUM_INFO_URL, API_KEY, album.albumMbid];
    NSData* jsonData = [self contentsOfUrl:urlString];
    if (jsonData)
    {
        NSError* error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == nil)
        {
            [self updateAlbumInfo:album withJson:json error:error];
        }
    }
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

- (void) chartEntryForJson:(NSDictionary*)json completion:(CREATION_COMPLETION)completion
{
    __block MGMChartEntry* finalChartEntry = nil;
    __block NSError* finalError = nil;

    NSString* rankString = [[json objectForKey:@"@attr"] objectForKey:@"rank"];
    NSString* listenersString = [json objectForKey:@"playcount"];
    NSNumber* rank = [self.numberFormatter numberFromString:rankString];
    NSNumber* listeners = [self.numberFormatter numberFromString:listenersString];
    [self.coreDataDao createNewChartEntryForRank:rank listeners:listeners completion:^(MGMChartEntry* chartEntry, NSError* creationError)
    {
        finalChartEntry = chartEntry;
        finalError = creationError;

        [self albumForJson:json completion:^(MGMAlbum* album, NSError* albumError)
        {
            finalError = albumError;
            chartEntry.album = album;
            completion(finalChartEntry, finalError);
        }];
    }];
}

- (void) albumForJson:(NSDictionary*)json completion:(CREATION_COMPLETION)completion
{
    __block MGMAlbum* finalAlbum = nil;
    __block NSError* finalError = nil;

    NSString* mbid = [json objectForKey:@"mbid"];

    [self.coreDataDao fetchAlbum:mbid completion:^(MGMAlbum* fetchedAlbum, NSError* fetchError)
    {
        finalAlbum = fetchedAlbum;
        finalError = fetchError;

        if (fetchedAlbum == nil)
        {
            NSDictionary* artist = [json objectForKey:@"artist"];
            NSString* artistName = [artist objectForKey:@"#text"];
            NSString* albumName = [json objectForKey:@"name"];
            [self.coreDataDao createNewAlbumForMbid:mbid artistName:artistName albumName:albumName score:nil completion:^(MGMAlbum* newAlbum, NSError* creationError)
            {
                finalAlbum = newAlbum;
                finalError = creationError;
            }];
        }

        completion(finalAlbum, finalError);
    }];
}
     
- (void) updateAlbumInfo:(MGMAlbum*)album withJson:(NSDictionary*)json completion:(VOID_COMPLETION)completion
{
    NSMutableDictionary* imageUris = [NSMutableDictionary dictionary];
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
                [imageUris setObject:value forKey:[NSNumber numberWithInteger:size]];
            }
        }
    }

    [self.coreDataDao addImageUris:imageUris toAlbum:album completion:completion];
}

@end
