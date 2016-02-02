//
//  MGMTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMTestCase.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>

@import ObjectiveC;

@interface MGMDefaultMockContainer ()

@property (nonatomic, strong) NSMutableArray *mockObjects;

@end

@implementation MGMDefaultMockContainer

- (void)addMockObject:(id)mockObject
{
    [self.mockObjects addObject:mockObject];
}

- (void)removeAllMockObjects
{
    for (id mock in self.mockObjects) {
        MKTStopMocking(mock);
    }

    [self.mockObjects removeAllObjects];
}

@end

@interface MGMTestCase ()

@property (nonatomic, strong) MGMDefaultMockContainer *mockContainer;

@end

@implementation MGMTestCase

- (void)setUp
{
    [super setUp];

    self.mockContainer = [[MGMDefaultMockContainer alloc] init];
}

- (void)tearDown
{
    [self removeAllMockObjects];

    Class currentClass = self.class;
    while (currentClass && currentClass != [MGMTestCase class]) {
        [self nillifyAllObjectIvarsInClass:currentClass];
        currentClass = class_getSuperclass(currentClass);
    }

    self.mockContainer = nil;

    [super tearDown];
}

- (void)nillifyAllObjectIvarsInClass:(Class)testClass
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(testClass, &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
        if ([self isObjectIvar:ivar]) {
            [self setValue:nil forKey:name];
        }
    }
    free(ivarList);
}

- (BOOL)isObjectIvar:(Ivar)ivar
{
    const char *type = ivar_getTypeEncoding(ivar);
    NSString *typeString = [NSString stringWithUTF8String:type];
    NSString *objectPropertyType = [NSString stringWithUTF8String:@encode(id)];
    return [typeString hasPrefix:objectPropertyType];
}

+ (id)mockObject:(Class)mockClass withContainer:(id<MGMMockContainer>)container
{
    id mock = MKTMock(mockClass);
    [container addMockObject:mock];
    return mock;
}

- (id)mockObject:(Class)mockClass
{
    return [[self class] mockObject:mockClass withContainer:self];
}


+ (id)mockClass:(Class)mockClass withContainer:(id<MGMMockContainer>)container
{
    id mock = MKTMockClass(mockClass);
    [container addMockObject:mock];
    return mock;
}

- (id)mockClass:(Class)mockClass
{
    return [[self class] mockClass:mockClass withContainer:self];
}

+ (id)mockProtocol:(Protocol *)mockProtocol withContainer:(id<MGMMockContainer>)container
{
    id mock = MKTMockProtocol(mockProtocol);
    [container addMockObject:mock];
    return mock;
}

- (id)mockProtocol:(Protocol *)mockProtocol
{
    return [[self class] mockProtocol:mockProtocol withContainer:self];
}


+ (id)mockObject:(Class)mockClass andProtocol:(Protocol *)mockProtocol withContainer:(id<MGMMockContainer>)container
{
    id mock = MKTMockObjectAndProtocol(mockClass, mockProtocol);
    [container addMockObject:mock];
    return mock;
}

- (id)mockObject:(Class)mockClass andProtocol:(Protocol *)mockProtocol
{
    return [[self class] mockObject:mockClass andProtocol:mockProtocol withContainer:self];
}


- (void)addMockObject:(id)mockObject
{
    [self.mockContainer addMockObject:mockObject];
}

- (void)removeAllMockObjects
{
    [self.mockContainer removeAllMockObjects];
}

@end
