//
//  MGMDaoOperationTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MGMDaoOperation.h"
#import <OCMock/OCMock.h>

static id _mockLocalDataSource;
static id _mockRemoteDataSource;
static NSUInteger _mockDaysBetweenRemoteFetch;

@interface MGMMockNextUrlAccess : NSObject

@property (strong) NSDate* date;
@property (strong) NSString* checksum;

@end

@implementation MGMMockNextUrlAccess

@end

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
    return _mockDaysBetweenRemoteFetch;
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    return key;
}

@end

@interface MGMDaoOperationTestCase : XCTestCase

@property (strong) id mockCoreDataAccess;
@property (strong) MGMDaoOperationForTesting* cut;

@end

@implementation MGMDaoOperationTestCase

+ (void) setUp
{
    _mockLocalDataSource = [OCMockObject mockForClass:[MGMLocalDataSource class]];
    _mockRemoteDataSource = [OCMockObject mockForClass:[MGMRemoteDataSource class]];
}

+ (void) tearDown
{
    _mockLocalDataSource = nil;
    _mockRemoteDataSource = nil;
}

- (void)setUp
{
    [super setUp];

    self.mockCoreDataAccess = [OCMockObject mockForClass:[MGMCoreDataAccess class]];
    self.cut = [[MGMDaoOperationForTesting alloc] initWithCoreDataAccess:self.mockCoreDataAccess];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    [[[self.mockCoreDataAccess expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained CORE_DATA_FETCH_COMPLETION completion;
        [invocation getArgument:&completion atIndex:3];
        completion(moid, error);
    }] fetchNextUrlAccessWithIdentifier:key completion:OCMOCK_ANY];
}

- (void) expect_MGMRemoteDataSource_fetchRemoteData:(id)key andReturn:(MGMRemoteData*)remoteData
{
    [[[_mockRemoteDataSource expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained REMOTE_DATA_FETCH_COMPLETION completion;
        [invocation getArgument:&completion atIndex:3];
        completion(remoteData);
    }] fetchRemoteData:key completion:OCMOCK_ANY];
}

- (void) expect_MGMLocalDataSource_persistRemoteData:(MGMRemoteData*)remoteData key:(id)key andReturn:(NSError*)error
{
    [[[_mockLocalDataSource expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained LOCAL_DATA_PERSIST_COMPLETION completion;
        [invocation getArgument:&completion atIndex:4];
        completion(error);
    }] persistRemoteData:remoteData key:key completion:OCMOCK_ANY];
}

- (void) expect_MGMCoreDataAccess_persistNextUrlAccess:(id)key
{
    [[[self.mockCoreDataAccess expect] andDo:^(NSInvocation* invocation) {
        // TODO: Test date difference?

        __unsafe_unretained LOCAL_DATA_PERSIST_COMPLETION completion;
        [invocation getArgument:&completion atIndex:4];
        completion(nil);
    }] persistNextUrlAccess:key date:OCMOCK_ANY completion:OCMOCK_ANY];
}

- (void) expect_MGMLocalDataSource_fetchLocalData:(id)key andReturn:(MGMLocalData*)localData
{
    [[[_mockLocalDataSource expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained LOCAL_DATA_FETCH_COMPLETION completion;
        [invocation getArgument:&completion atIndex:3];
        completion(localData);
    }] fetchLocalData:key completion:OCMOCK_ANY];
}

- (void) testInitialFetch
{
    NSManagedObjectID* mockNextUrlAccessMoid = [OCMockObject mockForClass:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];
    [[[self.mockCoreDataAccess expect] andReturn:nil] mainThreadVersion:mockNextUrlAccessMoid];

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
    NSManagedObjectID* mockNextUrlAccessMoid = [OCMockObject mockForClass:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];

    MGMMockNextUrlAccess* nextUrlAccess = [[MGMMockNextUrlAccess alloc] init];
    nextUrlAccess.date = [self daysAfterNow:1];
    [[[self.mockCoreDataAccess expect] andReturn:nextUrlAccess] mainThreadVersion:mockNextUrlAccessMoid];

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
    NSManagedObjectID* mockNextUrlAccessMoid = [OCMockObject mockForClass:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];

    MGMMockNextUrlAccess* nextUrlAccess = [[MGMMockNextUrlAccess alloc] init];
    nextUrlAccess.date = [self daysAfterNow:0];
    nextUrlAccess.checksum = @"SomeRemoteDataChecksum";
    [[[self.mockCoreDataAccess expect] andReturn:nextUrlAccess] mainThreadVersion:mockNextUrlAccessMoid];

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
    NSManagedObjectID* mockNextUrlAccessMoid = [OCMockObject mockForClass:[NSManagedObjectID class]];
    [self expect_MGMCoreDataAccess_fetchNextUrlAccessWithIdentifier:@"KEY" andReturnMoid:mockNextUrlAccessMoid andReturnError:nil];

    MGMMockNextUrlAccess* nextUrlAccess = [[MGMMockNextUrlAccess alloc] init];
    nextUrlAccess.date = [self daysAfterNow:0];
    nextUrlAccess.checksum = @"SomeRemoteDataChecksum";
    [[[self.mockCoreDataAccess expect] andReturn:nextUrlAccess] mainThreadVersion:mockNextUrlAccessMoid];

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
