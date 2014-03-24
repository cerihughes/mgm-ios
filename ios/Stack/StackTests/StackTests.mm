//
//  StackTests.m
//  StackTests
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SIPStack.h"

#import "CPPStack.h"

@interface StackTests : XCTestCase

@end

@implementation StackTests

- (void)testExample
{
    SIPStack* cut = [[SIPStack alloc] init];

    XCTAssertTrue([cut push:@1]);
    XCTAssertTrue([cut push:@2]);
    XCTAssertTrue([cut push:@3]);
    XCTAssertTrue([cut push:@4]);
    XCTAssertTrue([cut push:@5]);
    XCTAssertTrue([cut push:@6]);
    XCTAssertTrue([cut push:@7]);
    XCTAssertTrue([cut push:@8]);
    XCTAssertTrue([cut push:@9]);

    XCTAssertEqualObjects(@9, [cut pop]);
    XCTAssertEqualObjects(@8, [cut pop]);
    XCTAssertEqualObjects(@7, [cut pop]);
    XCTAssertEqualObjects(@6, [cut pop]);
    XCTAssertEqualObjects(@5, [cut pop]);
    XCTAssertEqualObjects(@4, [cut pop]);
    XCTAssertEqualObjects(@3, [cut pop]);
    XCTAssertEqualObjects(@2, [cut pop]);
    XCTAssertEqualObjects(@1, [cut pop]);
}

- (void)testCppExample
{
    sip::Stack<int>* cut = new sip::Stack<int>();

    XCTAssertTrue(cut->push(1));

}
@end
