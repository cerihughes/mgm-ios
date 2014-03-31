//
//  DSAHeapSortTestCase.m
//  DataStructuresAndAlgorithms
//
//  Created by Ceri Hughes on 31/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSAHeapSort.h"

@interface DSAHeapSortTestCase : XCTestCase

@property (nonatomic, strong) DSAHeapSort* cut;

@end

@implementation DSAHeapSortTestCase

- (void)setUp
{
    [super setUp];

    self.cut = [[DSAHeapSort alloc] init];
}

- (void) testSimpleSort
{
    NSArray* data = @[@1, @3, @5, @7, @9, @8, @6, @4, @2];
    NSArray* sorted = [self.cut heapSort:data];
    NSArray* expected = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
    XCTAssertEqualObjects(sorted, expected);
}

@end
