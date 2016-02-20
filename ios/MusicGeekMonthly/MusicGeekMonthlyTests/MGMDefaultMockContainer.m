//
//  MGMDefaultMockContainer.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMDefaultMockContainer.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>

@interface MGMDefaultMockContainer ()

@property (nonatomic, strong) NSMutableArray *mockObjects;

@end

@implementation MGMDefaultMockContainer

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
