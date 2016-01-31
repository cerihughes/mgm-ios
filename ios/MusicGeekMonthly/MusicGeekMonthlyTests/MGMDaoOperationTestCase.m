//
//  MGMDaoOperationTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMTestCase.h"

#import "MGMDaoOperation.h"

#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

static id _mockLocalDataSource;
static id _mockRemoteDataSource;

@interface MGMDaoOperationForTesting : MGMDaoOperation

@end

@implementation MGMDaoOperationForTesting

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess *)coreDataAccess
{
    return _mockLocalDataSource;
}

- (MGMRemoteDataSource*) createRemoteDataSource
{
    return _mockRemoteDataSource;
}

- (NSUInteger) daysBetweenRemoteFetch
{
    return 0;
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    return key;
}

@end

@interface MGMDaoOperationTestCase : MGMTestCase

@property (strong) id mockCoreDataAccess;
@property (strong) MGMDaoOperationForTesting* cut;

@end

@implementation MGMDaoOperationTestCase

- (void)setUp
{
    [super setUp];

    _mockLocalDataSource = [self mockObject:[MGMLocalDataSource class]];
    _mockRemoteDataSource = [self mockObject:[MGMRemoteDataSource class]];

    self.mockCoreDataAccess = [self mockObject:[MGMCoreDataAccess class]];
    self.cut = [[MGMDaoOperationForTesting alloc] initWithCoreDataAccess:self.mockCoreDataAccess];
}

- (void)tearDown
{
    _mockLocalDataSource = nil;
    _mockRemoteDataSource = nil;

    [super tearDown];
}

- (NSDate*) daysAfterNow:(NSUInteger)days;
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = days;

    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
}

- (void) expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:(id)key andReturnMoid:(NSManagedObjectID*)moid andReturnError:(NSError*)error
{
    [MKTGivenVoid([self.mockCoreDataAccess fetchNextUrlAccessWithIdentifier:key completion:anything()]) willDo:^id(NSInvocation *invocation) {
        CORE_DATA_FETCH_COMPLETION completion = [invocation mkt_arguments][1];
        completion(moid, error);
        return nil;
    }];
}

- (void) expect_MGMRemoteDataSource_fetchRemoteData:(id)key andReturn:(MGMRemoteData*)remoteData
{
    [MKTGivenVoid([_mockRemoteDataSource fetchRemoteData:key completion:anything()]) willDo:^id(NSInvocation *invocation) {
        REMOTE_DATA_FETCH_COMPLETION completion = [invocation mkt_arguments][1];
        completion(remoteData);
        return nil;
    }];
}

- (void) expect_MGMLocalDataSource_persistRemoteData:(MGMRemoteData*)remoteData key:(id)key andReturn:(NSError*)error
{
    [MKTGivenVoid([_mockLocalDataSource persistRemoteData:remoteData key:key completion:anything()]) willDo:^id(NSInvocation *invocation) {
        LOCAL_DATA_PERSIST_COMPLETION completion = [invocation mkt_arguments][2];
        completion(error);
        return nil;
    }];
}

- (void) expect_MGMCoreDataAccess_persistNextUrlAccess:(id)key
{
    [MKTGivenVoid([self.mockCoreDataAccess persistNextUrlAccess:key date:anything() completion:anything()]) willDo:^id(NSInvocation *invocation) {
        // TODO: Test date difference?

        LOCAL_DATA_PERSIST_COMPLETION completion = [invocation mkt_arguments][2];
        completion(nil);
        return nil;
    }];
}

- (void) expect_MGMLocalDataSource_fetchLocalData:(id)key andReturn:(MGMLocalData*)localData
{
    [MKTGivenVoid([_mockLocalDataSource fetchLocalData:key completion:anything()]) willDo:^id(NSInvocation *invocation) {
        LOCAL_DATA_FETCH_COMPLETION completion = [invocation mkt_arguments][1];
        completion(localData);
        return nil;
    }];
}

- (void) testInitialFetch
{
    NSManagedObjectID* mockNextUrlAccessMoid = [self mockObject:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];
    [MKTGiven([self.mockCoreDataAccess mainThreadVersion:mockNextUrlAccessMoid]) willReturn:nil];

    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = @"SomeRemoteData";
    remoteData.checksum = @"SomeRemoteDataChecksum";

    [self expect_MGMRemoteDataSource_fetchRemoteData:@"KEY" andReturn:remoteData];
    [self expect_MGMLocalDataSource_persistRemoteData:remoteData key:@"KEY" andReturn:nil];
    [self expect_MGMCoreDataAccess_persistNextUrlAccess:@"KEY"];

    MGMLocalData* localData = [[MGMLocalData alloc] init];
    localData.data = @"SomeLocalData";

    [self expect_MGMLocalDataSource_fetchLocalData:@"KEY" andReturn:localData];

    // Let's go...
    [self.cut fetchData:@"KEY" completion:^(MGMDaoData* daoData) {
        XCTAssertNil(daoData.error, @"Expecting no error.");
        XCTAssertEqualObjects(@"SomeLocalData", daoData.data, @"Expecting equlity.");
        XCTAssertTrue(daoData.isNew, @"Expecting new data");
    }];
}

- (void) testSubsequentFetchWithin24Hours
{
    NSManagedObjectID* mockNextUrlAccessMoid = [self mockObject:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];

    MGMNextUrlAccess* nextUrlAccess = [self mockObject:[MGMNextUrlAccess class]];
    [MKTGiven([nextUrlAccess date]) willReturn:[self daysAfterNow:1]];
    [MKTGiven([self.mockCoreDataAccess mainThreadVersion:mockNextUrlAccessMoid]) willReturn:nextUrlAccess];

    MGMLocalData* localData = [[MGMLocalData alloc] init];
    localData.data = @"SomeLocalData";

    [self expect_MGMLocalDataSource_fetchLocalData:@"KEY" andReturn:localData];

    // Let's go...
    [self.cut fetchData:@"KEY" completion:^(MGMDaoData* daoData) {
        XCTAssertNil(daoData.error, @"Expecting no error.");
        XCTAssertEqualObjects(@"SomeLocalData", daoData.data, @"Expecting equlity.");
        XCTAssertFalse(daoData.isNew, @"Expecting old data");
    }];
}

- (void) testSubsequentFetchAfter24HoursUnchangedData
{
    NSManagedObjectID* mockNextUrlAccessMoid = [self mockObject:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];

    MGMNextUrlAccess* nextUrlAccess = [self mockObject:[MGMNextUrlAccess class]];
    [MKTGiven([nextUrlAccess date]) willReturn:[self daysAfterNow:0]];
    [MKTGiven([nextUrlAccess checksum]) willReturn:@"SomeRemoteDataChecksum"];
    [MKTGiven([self.mockCoreDataAccess mainThreadVersion:mockNextUrlAccessMoid]) willReturn:nextUrlAccess];

    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = @"SomeRemoteData";
    remoteData.checksum = @"SomeRemoteDataChecksum";

    [self expect_MGMRemoteDataSource_fetchRemoteData:@"KEY" andReturn:remoteData];
    [self expect_MGMCoreDataAccess_persistNextUrlAccess:@"KEY"];

    MGMLocalData* localData = [[MGMLocalData alloc] init];
    localData.data = @"SomeLocalData";

    [self expect_MGMLocalDataSource_fetchLocalData:@"KEY" andReturn:localData];

    // Let's go...
    [self.cut fetchData:@"KEY" completion:^(MGMDaoData* daoData) {
        XCTAssertNil(daoData.error, @"Expecting no error.");
        XCTAssertEqualObjects(@"SomeLocalData", daoData.data, @"Expecting equlity.");
        XCTAssertFalse(daoData.isNew, @"Expecting old data");
    }];
}

- (void) testSubsequentFetchAfter24HoursChangedData
{
    NSManagedObjectID* mockNextUrlAccessMoid = [self mockObject:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];

    MGMNextUrlAccess* nextUrlAccess = [self mockObject:[MGMNextUrlAccess class]];
    [MKTGiven([nextUrlAccess date]) willReturn:[self daysAfterNow:0]];
    [MKTGiven([nextUrlAccess checksum]) willReturn:@"SomeRemoteDataChecksum"];
    [MKTGiven([self.mockCoreDataAccess mainThreadVersion:mockNextUrlAccessMoid]) willReturn:nextUrlAccess];

    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = @"SomeRemoteData";
    remoteData.checksum = @"AnotherRemoteDataChecksum";

    [self expect_MGMRemoteDataSource_fetchRemoteData:@"KEY" andReturn:remoteData];
    [self expect_MGMLocalDataSource_persistRemoteData:remoteData key:@"KEY" andReturn:nil];
    [self expect_MGMCoreDataAccess_persistNextUrlAccess:@"KEY"];

    MGMLocalData* localData = [[MGMLocalData alloc] init];
    localData.data = @"SomeLocalData";

    [self expect_MGMLocalDataSource_fetchLocalData:@"KEY" andReturn:localData];

    // Let's go...
    [self.cut fetchData:@"KEY" completion:^(MGMDaoData* daoData) {
        XCTAssertNil(daoData.error, @"Expecting no error.");
        XCTAssertEqualObjects(@"SomeLocalData", daoData.data, @"Expecting equlity.");
        XCTAssertTrue(daoData.isNew, @"Expecting new data");
    }];
}

@end
