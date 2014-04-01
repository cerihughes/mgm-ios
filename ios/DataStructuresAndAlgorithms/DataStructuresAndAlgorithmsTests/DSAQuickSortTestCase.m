//
//  DSAQuickSortTestCase.m
//  DataStructuresAndAlgorithms
//
//  Created by Home on 01/04/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSAQuickSort.h"

@interface DSAQuickSortTestCase : XCTestCase

@property (nonatomic, strong) DSAQuickSort* cut;

@end

@implementation DSAQuickSortTestCase

- (void)setUp
{
    [super setUp];

    self.cut = [[DSAQuickSort alloc] init];
}

- (void) testSimpleSort
{
    NSArray* data = @[@1, @3, @5, @7, @9, @8, @6, @4, @2];
    NSArray* sorted = [self.cut quickSort:data];
    NSArray* expected = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
    XCTAssertEqualObjects(sorted, expected);
}

@end
