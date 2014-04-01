//
//  DSAMergeSortTestCase.m
//  DataStructuresAndAlgorithms
//
//  Created by Home on 01/04/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSAMergeSort.h"

@interface DSAMergeSortTestCase : XCTestCase

@property (nonatomic, strong) DSAMergeSort* cut;

@end

@implementation DSAMergeSortTestCase

- (void) setUp
{
    [super setUp];

    self.cut = [[DSAMergeSort alloc] init];
}

- (void) testSimpleSort
{
    NSArray* data = @[@1, @3, @5, @7, @9, @8, @6, @4, @2];
    NSArray* sorted = [self.cut mergeSort:data];
    NSArray* expected = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
    XCTAssertEqualObjects(sorted, expected);
}

@end
