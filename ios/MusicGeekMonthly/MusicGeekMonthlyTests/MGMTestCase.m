//
//  MGMTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMTestCase.h"

#import "MGMDefaultMockContainer.h"
#import "MGMTestCaseUtilities.h"

@interface MGMTestCase ()

@property (nonatomic, strong) MGMTestCaseUtilities *utilities;

@end

@implementation MGMTestCase

- (void)setUp
{
    [super setUp];

    _mockContainer = [[MGMDefaultMockContainer alloc] init];
    _utilities = [[MGMTestCaseUtilities alloc] initWithTestCase:self parentTestClass:[MGMTestCase class]];
}

- (void)tearDown
{
    [self.mockContainer removeAllMockObjects];
    [self.utilities nillifyAllTestCaseIvars];

    _mockContainer = nil;
    _utilities = nil;

    [super tearDown];
}

@end
