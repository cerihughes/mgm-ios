//
//  MGMTestCaseUtilities.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMTestCaseUtilities : NSObject

- (instancetype)initWithTestCase:(NSObject *)testCase parentTestClass:(Class)parentTestClass;

- (void)nillifyAllTestCaseIvars;

@end
