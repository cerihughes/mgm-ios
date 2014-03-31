//
//  SCWheelGameTestCase.m
//  Spotify Challenges
//
//  Created by Ceri Hughes on 29/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SCWheelGame.h"

@interface SCWheelGameTestCase : XCTestCase

@property (nonatomic, strong) SCWheelGame* cut;

@end

@implementation SCWheelGameTestCase

- (void)setUp
{
    [super setUp];

    self.cut = [[SCWheelGame alloc] init];
}

- (void) testForDestroy
{
    XCTAssertEqualObjects(@"Destroy the robot before it is too late", [self.cut playWheelGameWithSpokes:5]);
}

- (void) testForFriend
{
    XCTAssertEqualObjects(@"The robot is your friend", [self.cut playWheelGameWithSpokes:5]);
}

@end
