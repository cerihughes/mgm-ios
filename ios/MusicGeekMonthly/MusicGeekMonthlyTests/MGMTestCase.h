//
//  MGMTestCase.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

@import XCTest;

@class MGMDefaultMockContainer;

@interface MGMTestCase : XCTestCase

@property (nonatomic, readonly) MGMDefaultMockContainer *mockContainer;

@end
