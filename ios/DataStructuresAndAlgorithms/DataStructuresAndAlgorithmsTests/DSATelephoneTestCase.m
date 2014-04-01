//
//  DSATelephoneTestCase.m
//  DataStructuresAndAlgorithms
//
//  Created by Home on 01/04/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSATelephoneTest.h"

@interface DSATelephoneTestCase : XCTestCase

@property (nonatomic, strong) DSATelephoneTest* cut;

@end

@implementation DSATelephoneTestCase

- (void) setUp
{
    [super setUp];

    self.cut = [[DSATelephoneTest alloc] init];
}

- (void) testSimpleCase
{
    NSArray* expected = @[@"1A", @"1B", @"1C"];
    NSArray* actual = [self.cut combinationsForNumber:@"12"];
    XCTAssertEqualObjects(expected, actual);
}

- (void) testAnotherSimpleCase
{
    NSArray* expected = @[@"1A0", @"1B0", @"1C0"];
    NSArray* actual = [self.cut combinationsForNumber:@"120"];
    XCTAssertEqualObjects(expected, actual);
}

- (void) testMoreComplexCase
{
    NSArray* expected = @[@"AD", @"AE", @"AF", @"BD", @"BE", @"BF", @"CD", @"CE", @"CF"];
    NSArray* actual = [self.cut combinationsForNumber:@"23"];
    XCTAssertEqualObjects(expected, actual);
}

- (void) testEmptyCase
{
    NSArray* expected = @[];
    NSArray* actual = [self.cut combinationsForNumber:@""];
    XCTAssertEqualObjects(expected, actual);
}

@end
