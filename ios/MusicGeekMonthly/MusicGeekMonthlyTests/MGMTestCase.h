//
//  MGMTestCase.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import <XCTest/XCTest.h>

@protocol MGMMockContainer <NSObject>

- (void)addMockObject:(id)mockObject;
- (void)removeAllMockObjects;

@end

@protocol MGMMockGenerator <MGMMockContainer>

+ (id)mockObject:(Class)mockClass withContainer:(id<MGMMockContainer>)container;
- (id)mockObject:(Class)mockClass;

+ (id)mockClass:(Class)mockClass withContainer:(id<MGMMockContainer>)container;
- (id)mockClass:(Class)mockClass;

+ (id)mockProtocol:(Protocol *)mockProtocol withContainer:(id<MGMMockContainer>)container;
- (id)mockProtocol:(Protocol *)mockProtocol;

+ (id)mockObject:(Class)mockClass andProtocol:(Protocol *)mockProtocol withContainer:(id<MGMMockContainer>)container;
- (id)mockObject:(Class)mockClass andProtocol:(Protocol *)mockProtocol;

@end

@interface MGMDefaultMockContainer : NSObject <MGMMockContainer>

@end

@interface MGMTestCase : XCTestCase <MGMMockGenerator>

@end
