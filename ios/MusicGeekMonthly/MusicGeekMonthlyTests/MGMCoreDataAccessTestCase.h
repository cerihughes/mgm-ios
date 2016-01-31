//
//  MGMCoreDataAccessTestCase.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MGMCoreDataAccess.h"

@interface MGMCoreDataAccessTestCase : XCTestCase

@property (readonly) MGMCoreDataAccess* cutInsert;
@property (readonly) MGMCoreDataAccess* cutFetch;
@property (readonly) NSDateFormatter* dateFormatter;

- (void) deleteAllObjects:(NSString*)objectType;

@end
