//
//  MGMTestCaseUtilities.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMTestCaseUtilities.h"

@import ObjectiveC;

@interface MGMTestCaseUtilities ()

@property (nonatomic, weak) NSObject *testCase;
@property (nonatomic) Class parentTestClass;

@end

@implementation MGMTestCaseUtilities

- (instancetype)initWithTestCase:(NSObject *)testCase parentTestClass:(Class)parentTestClass
{
    self = [super init];
    if (self) {
        _testCase = testCase;
        _parentTestClass = parentTestClass;
    }
    return self;
}

- (void)nillifyAllTestCaseIvars
{
    Class currentClass = self.testCase.class;
    while (currentClass && currentClass != self.parentTestClass) {
        [self nillifyAllObjectIvarsInObject:self.testCase forClass:currentClass];
        currentClass = class_getSuperclass(currentClass);
    }
}

- (void)nillifyAllObjectIvarsInObject:(NSObject *)object forClass:(Class)testClass
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(testClass, &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        if ([self isObjectIvar:ivar]) {
            object_setIvar(object, ivar, nil);
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

@end
