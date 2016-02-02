//
//  MGMCoreDataAccessTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataAccessTestCase.h"

#import "MGMAlbumImageUriDto.h"
#import "MGMAlbumMetadataDto.h"
#import "MGMCoreDataAccess.h"
#import "MGMEventDto.h"
#import "MGMTimePeriod.h"
#import "MGMTimePeriodDto.h"
#import "MGMWeeklyChart.h"
#import "MGMWeeklyChartDto.h"

@interface MGMCoreDataAccess (MGMCoreDataAccessTestCase)

@property (readonly) NSManagedObjectContext* masterMoc;

- (id) initWithStoreName:(NSString*)storeName;

@end

@interface MGMCoreDataAccessTestCase ()

@property (strong) MGMCoreDataAccess* cutInsert;
@property (strong) MGMCoreDataAccess* cutFetch;
@property (strong) NSDateFormatter* dateFormatter;

@end

@implementation MGMCoreDataAccessTestCase

#define TEST_STORE_NAME @"MusicGeekMonthyTests.sqlite"

- (void) setUp
{
    [super setUp];
    
    self.cutInsert = [[MGMCoreDataAccess alloc] initWithStoreName:TEST_STORE_NAME];
    self.cutFetch = [[MGMCoreDataAccess alloc] initWithStoreName:TEST_STORE_NAME];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
}

- (void) deleteAllObjects:(NSString*)objectType
{
    NSManagedObjectContext* managedObjectContext = self.cutFetch.masterMoc;
    NSFetchRequest* fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:objectType inManagedObjectContext:managedObjectContext];
    [fetch setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError* error = nil;
    NSArray* allObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    assert(error == nil);
    for (NSManagedObject* object in allObjects)
    {
        [managedObjectContext deleteObject:object];
    }

    [managedObjectContext save:&error];
    assert(error == nil);
}

@end
