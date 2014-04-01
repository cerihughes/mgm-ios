//
//  DSAMergeSort.m
//  DataStructuresAndAlgorithms
//
//  Created by Home on 01/04/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "DSAMergeSort.h"

@implementation DSAMergeSort

- (NSArray*) mergeSort:(NSArray *)array
{
    if ([array count] < 2)
    {
        return array;
    }

    NSUInteger lastIndex = [array count] ;
    NSUInteger midIndex = lastIndex / 2;
    NSRange leftRange = NSMakeRange(0, midIndex);
    NSRange rightRange = NSMakeRange(midIndex, lastIndex - midIndex);
    NSArray* leftArray = [array subarrayWithRange:leftRange];
    NSArray* rightArray = [array subarrayWithRange:rightRange];

    NSArray* sortedLeftArray = [self mergeSort:leftArray];
    NSArray* sortedRightArray = [self mergeSort:rightArray];
    return [self mergeArray:sortedLeftArray withArray:sortedRightArray];
}

- (NSArray*) mergeArray:(NSArray*)array1 withArray:(NSArray*)array2
{
    NSUInteger arraySize1 = [array1 count];
    NSUInteger arraySize2 = [array2 count];

    NSMutableArray* merged = [NSMutableArray arrayWithCapacity:arraySize1 + arraySize2];

    NSUInteger arrayCounter1 = 0;
    NSUInteger arrayCounter2 = 0;

    while (arrayCounter1 < arraySize1 && arrayCounter2 < arraySize2)
    {
        NSNumber* node1 = array1[arrayCounter1];
        NSNumber* node2 = array2[arrayCounter2];

        if ([node1 intValue] < [node2 intValue])
        {
            [merged addObject:node1];
            arrayCounter1++;
        }
        else
        {
            [merged addObject:node2];
            arrayCounter2++;
        }
    }

    NSRange remainingRange1 = NSMakeRange(arrayCounter1, arraySize1 - arrayCounter1);
    NSRange remainingRange2 = NSMakeRange(arrayCounter2, arraySize2 - arrayCounter2);
    NSArray* remainingArray1 = [array1 subarrayWithRange:remainingRange1];
    NSArray* remainingArray2 = [array2 subarrayWithRange:remainingRange2];
    
    [merged addObjectsFromArray:remainingArray1];
    [merged addObjectsFromArray:remainingArray2];

    return [merged copy];
}

@end
