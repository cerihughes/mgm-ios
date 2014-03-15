//
//  MGMGridManagerTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 02/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MGMGridManager.h"

@interface MGMGridManagerTestCase : XCTestCase

@end

@implementation MGMGridManagerTestCase

- (void) testRowCount4ItemCount1
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:1 count:1];
    CGFloat resultData[] = {0, 0, 4, 4};
    NSArray* expectedResults = [self createExpectedResults:resultData count:1];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount2
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:1 count:2];
    CGFloat resultData[] = {0, 0, 2, 2,
        2, 0, 2, 2};
    NSArray* expectedResults = [self createExpectedResults:resultData count:2];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount3
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:3 count:3];
    CGFloat resultData[] = {0, 0, 4, 4,
        4, 0, 4, 4,
        8, 0, 4, 4};
    NSArray* expectedResults = [self createExpectedResults:resultData count:3];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount4
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:1 count:4];
    CGFloat resultData[] = {0, 0, 1, 1,
        1, 0, 1, 1,
        2, 0, 1, 1,
        3, 0, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:4];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount5
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:1 count:5];
    CGFloat resultData[] = {0, 0, 2, 2,
        2, 0, 1, 1,
        3, 0, 1, 1,
        2, 1, 1, 1,
        3, 1, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:5];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount6
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:3 count:6];
    CGFloat resultData[] = {0, 0, 4, 4,
        4, 0, 4, 4,
        8, 0, 4, 4,
        0, 4, 4, 4,
        4, 4, 4, 4,
        8, 4, 4, 4};
    NSArray* expectedResults = [self createExpectedResults:resultData count:6];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount7
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:3 count:7];
    CGFloat resultData[] = {0, 0, 4, 4,
        4, 0, 4, 4,
        8, 0, 4, 4,
        0, 4, 3, 3,
        3, 4, 3, 3,
        6, 4, 3, 3,
        9, 4, 3, 3};
    NSArray* expectedResults = [self createExpectedResults:resultData count:7];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount8
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:1 count:8];
    CGFloat resultData[] = {0, 0, 1, 1,
        1, 0, 1, 1,
        2, 0, 1, 1,
        3, 0, 1, 1,
        0, 1, 1, 1,
        1, 1, 1, 1,
        2, 1, 1, 1,
        3, 1, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:8];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount9
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:1 count:9];
    CGFloat resultData[] = {0, 0, 2, 2,
        2, 0, 1, 1,
        3, 0, 1, 1,
        2, 1, 1, 1,
        3, 1, 1, 1,
        0, 2, 1, 1,
        1, 2, 1, 1,
        2, 2, 1, 1,
        3, 2, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:9];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount4ItemCount25
{
    NSArray* grids = [self gridsForRowSize:4 defaultRectSize:1 count:25];
    CGFloat resultData[] = {0, 0, 2, 2,
        2, 0, 1, 1,
        3, 0, 1, 1,
        2, 1, 1, 1,
        3, 1, 1, 1,
        0, 2, 1, 1,
        1, 2, 1, 1,
        2, 2, 1, 1,
        3, 2, 1, 1,
        0, 3, 1, 1,
        1, 3, 1, 1,
        2, 3, 1, 1,
        3, 3, 1, 1,
        0, 4, 1, 1,
        1, 4, 1, 1,
        2, 4, 1, 1,
        3, 4, 1, 1,
        0, 5, 1, 1,
        1, 5, 1, 1,
        2, 5, 1, 1,
        3, 5, 1, 1,
        0, 6, 1, 1,
        1, 6, 1, 1,
        2, 6, 1, 1,
        3, 6, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:25];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount2ItemCount1
{
    NSArray* grids = [self gridsForRowSize:2 defaultRectSize:1 count:1];
    CGFloat resultData[] = {0, 0, 2, 2};
    NSArray* expectedResults = [self createExpectedResults:resultData count:1];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount2ItemCount2
{
    NSArray* grids = [self gridsForRowSize:2 defaultRectSize:1 count:2];
    CGFloat resultData[] = {0, 0, 1, 1,
        1, 0, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:2];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount2ItemCount3
{
    NSArray* grids = [self gridsForRowSize:2 defaultRectSize:1 count:3];
    CGFloat resultData[] = {0, 0, 2, 2,
        0, 2, 1, 1,
        1, 2, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:3];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount2ItemCount4
{
    NSArray* grids = [self gridsForRowSize:2 defaultRectSize:1 count:4];
    CGFloat resultData[] = {0, 0, 1, 1,
        1, 0, 1, 1,
        0, 1, 1, 1,
        1, 1, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:4];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount2ItemCount5
{
    NSArray* grids = [self gridsForRowSize:2 defaultRectSize:1 count:5];
    CGFloat resultData[] = {0, 0, 2, 2,
        0, 2, 1, 1,
        1, 2, 1, 1,
        0, 3, 1, 1,
        1, 3, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:5];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount2ItemCount25
{
    NSArray* grids = [self gridsForRowSize:2 defaultRectSize:1 count:25];
    CGFloat resultData[] = {0, 0, 2, 2,
        0, 2, 1, 1,
        1, 2, 1, 1,
        0, 3, 1, 1,
        1, 3, 1, 1,
        0, 4, 1, 1,
        1, 4, 1, 1,
        0, 5, 1, 1,
        1, 5, 1, 1,
        0, 6, 1, 1,
        1, 6, 1, 1,
        0, 7, 1, 1,
        1, 7, 1, 1,
        0, 8, 1, 1,
        1, 8, 1, 1,
        0, 9, 1, 1,
        1, 9, 1, 1,
        0, 10, 1, 1,
        1, 10, 1, 1,
        0, 11, 1, 1,
        1, 11, 1, 1,
        0, 12, 1, 1,
        1, 12, 1, 1,
        0, 13, 1, 1,
        1, 13, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:25];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (void) testRowCount5ItemCount25
{
    NSArray* grids = [self gridsForRowSize:5 defaultRectSize:1 count:25];
    CGFloat resultData[] = {0, 0, 1, 1,
        1, 0, 1, 1,
        2, 0, 1, 1,
        3, 0, 1, 1,
        4, 0, 1, 1,
        0, 1, 1, 1,
        1, 1, 1, 1,
        2, 1, 1, 1,
        3, 1, 1, 1,
        4, 1, 1, 1,
        0, 2, 1, 1,
        1, 2, 1, 1,
        2, 2, 1, 1,
        3, 2, 1, 1,
        4, 2, 1, 1,
        0, 3, 1, 1,
        1, 3, 1, 1,
        2, 3, 1, 1,
        3, 3, 1, 1,
        4, 3, 1, 1,
        0, 4, 1, 1,
        1, 4, 1, 1,
        2, 4, 1, 1,
        3, 4, 1, 1,
        4, 4, 1, 1};
    NSArray* expectedResults = [self createExpectedResults:resultData count:25];
    XCTAssertEqualObjects(grids, expectedResults, @"Expected rects to match.");
}

- (NSArray*) gridsForRowSize:(NSUInteger)rowSize defaultRectSize:(CGFloat)defualtRectSize count:(NSUInteger)count
{
    NSArray* grids = [MGMGridManager rectsForRowSize:rowSize defaultRectSize:defualtRectSize count:count];
    XCTAssertEqual(grids.count, (NSUInteger)count, @"Expecting different results.");
    return grids;
}

- (NSArray*) createExpectedResults:(CGFloat[])data count:(NSUInteger)count
{
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:count];

    for (NSUInteger i = 0; i < count; i++)
    {
        CGFloat x = data[(4 * i)];
        CGFloat y = data[(4 * i) + 1];
        CGFloat w = data[(4 * i) + 2];
        CGFloat h = data[(4 * i) + 3];

        CGRect rect = CGRectMake(x, y, w, h);
        [results addObject:[NSValue valueWithCGRect:rect]];
    }

    return [results copy];
}


@end
