//
//  SCConversionsTest.m
//  Spotify Challenges
//
//  Created by Ceri Hughes on 29/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SCConversions.h"

@interface SCConversionsTest : XCTestCase

@property (nonatomic, strong) SCConversions* cut;

@end

@implementation SCConversionsTest

- (void) setUp
{
    [super setUp];

    self.cut = [[SCConversions alloc] init];
}

- (void) testMilesToMiles
{
    XCTAssertEqual(123, [self.cut convert:@"123 mile in mi"]);
}

- (void) testFeetToInches
{
    XCTAssertEqual(504, [self.cut convert:@"42 ft in inch"]);
}

- (void) testFurlongsToLeagues
{
    NSString* expectedString = [NSString stringWithFormat:@"%.9lf", 0.4166666666667];
    NSString* actualString = [NSString stringWithFormat:@"%.9lf", [self.cut convert:@"10 furlong in lea"]];
    XCTAssertEqualObjects(expectedString, actualString);
}

@end
