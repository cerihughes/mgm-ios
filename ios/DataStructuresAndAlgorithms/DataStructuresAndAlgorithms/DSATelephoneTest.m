//
//  DSATelephoneTest.m
//  DataStructuresAndAlgorithms
//
//  Created by Home on 01/04/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "DSATelephoneTest.h"

@interface DSATelephoneTest ()

@property (nonatomic, strong) NSArray* conversions;

@end

@implementation DSATelephoneTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _conversions = @[@"0", @"1", @"A B C", @"D E F", @"G H I", @"J K L", @"M N O", @"P Q R S", @"T U V", @"W X Y Z"];
    }
    return self;
}
- (NSArray*) combinationsForNumber:(NSString*)number
{
    if ([number length] == 0)
    {
        return [NSArray array];
    }
    else
    {
        NSString* digit = [number substringToIndex:1];
        NSString* remainingNumbers = [number substringFromIndex:1];
        return [self combinationsForDigit:digit withRemainingNumbers:remainingNumbers];
    }
}

- (NSArray*) combinationsForDigit:(NSString*)digit withRemainingNumbers:(NSString*)remainingNumbers
{
    int index = [digit intValue];
    NSString* optionsForNumber = _conversions[index];
    NSArray* options = [optionsForNumber componentsSeparatedByString:@" "];

    if ([remainingNumbers length] == 0)
    {
        return options;
    }
    else
    {
        NSString* nextDigit = [remainingNumbers substringToIndex:1];
        NSString* nextRemainingNumbers = [remainingNumbers substringFromIndex:1];
        NSArray* nextCombinations = [self combinationsForDigit:nextDigit withRemainingNumbers:nextRemainingNumbers];
        return [self prependOptions:options toCombinations:nextCombinations];
    }
}

- (NSArray*) prependOptions:(NSArray*)options toCombinations:(NSArray*)combinations
{
    NSMutableArray* combinedArray = [NSMutableArray arrayWithCapacity:[options count] * [combinations count]];
    for (NSString* option in options)
    {
        for (NSString* combination in combinations)
        {
            [combinedArray addObject:[NSString stringWithFormat:@"%@%@", option, combination]];
        }
    }
    return [combinedArray copy];
}

@end
