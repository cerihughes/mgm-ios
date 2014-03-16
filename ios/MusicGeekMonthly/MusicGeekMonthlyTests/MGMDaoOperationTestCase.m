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

- (void) testInitialFetch
{
    NSManagedObjectID* mockNextUrlAccessMoid = [OCMockObject mockForClass:[NSManagedObjectID class]];

    [[[self.mockCoreDataAccess expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained CORE_DATA_FETCH_COMPLETION completion;
        [invocation getArgument:&completion atIndex:3];
        completion(mockNextUrlAccessMoid, nil);
    }] fetchNextUrlAccessWithIdentifier:@"KEY" completion:OCMOCK_ANY];

    [[[self.mockCoreDataAccess expect] andReturn:nil] mainThreadVersion:mockNextUrlAccessMoid];

    MGMRemoteData* remoteData = [[MGMRemoteData alloc] init];
    remoteData.data = @"SomeRemoteData";
    remoteData.checksum = @"SomeRemoteDataChecksum";

    [[[_mockRemoteDataSource expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained REMOTE_DATA_FETCH_COMPLETION completion;
        [invocation getArgument:&completion atIndex:3];
        completion(remoteData);
    }] fetchRemoteData:@"KEY" completion:OCMOCK_ANY];

    [[[_mockLocalDataSource expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained LOCAL_DATA_PERSIST_COMPLETION completion;
        [invocation getArgument:&completion atIndex:4];
        completion(nil);
    }] persistRemoteData:remoteData key:@"KEY" completion:OCMOCK_ANY];

    [[[self.mockCoreDataAccess expect] andDo:^(NSInvocation* invocation) {
        // TODO: Test date difference?

        __unsafe_unretained LOCAL_DATA_PERSIST_COMPLETION completion;
        [invocation getArgument:&completion atIndex:4];
        completion(nil);
    }] persistNextUrlAccess:@"KEY" date:OCMOCK_ANY completion:OCMOCK_ANY];

    MGMLocalData* localData = [[MGMLocalData alloc] init];
    localData.data = @"SomeLocalData";

    [[[_mockLocalDataSource expect] andDo:^(NSInvocation* invocation) {
        __unsafe_unretained LOCAL_DATA_FETCH_COMPLETION completion;
        [invocation getArgument:&completion atIndex:3];
        completion(localData);
    }] fetchLocalData:@"KEY" completion:OCMOCK_ANY];

    // Let's go...
    [self.cut fetchData:@"KEY" completion:^(MGMDaoData* daoData) {
        XCTAssertNil(daoData.error, @"Expecting no error.");
        XCTAssertEqualObjects(@"SomeLocalData", daoData.data, @"Expecting equlity.");
        XCTAssertTrue(daoData.isNew, @"Expecting new data");
    }];
}

@end
