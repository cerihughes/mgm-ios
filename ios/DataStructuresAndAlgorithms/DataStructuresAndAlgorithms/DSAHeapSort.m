//
//  DSAHeapSort.m
//  DataStructuresAndAlgorithms
//
//  Created by Ceri Hughes on 31/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "DSAHeapSort.h"

@implementation DSAHeapSort

- (NSArray*) heapSort:(NSArray*)array
{
    NSMutableArray* mutableArray = [array mutableCopy];
    [self inPlaceHeapSort:mutableArray];
    return [mutableArray copy];
}

- (void) inPlaceHeapSort:(NSMutableArray*)array
{
    [self heapify:array];
    int size = [array count];
    for (int i = size - 1; i >= 0; i--)
    {
        [self swapObjectAtIndex:0 withObjectAtIndex:i inArray:array];
        [self sinkNodeAtIndex:0 inArray:array toIndex:i - 1];
    }
}

- (void) heapify:(NSMutableArray*)array
{
    int size = [array count];
    for (int i = (size / 2) - 1; i >=0; i--)
    {
        [self sinkNodeAtIndex:i inArray:array];
    }
}

- (void) sinkNodeAtIndex:(int)nodeIndex inArray:(NSMutableArray*)array
{
    [self sinkNodeAtIndex:(int)nodeIndex inArray:array toIndex:[array count]];
}

- (void) sinkNodeAtIndex:(int)nodeIndex inArray:(NSMutableArray*)array toIndex:(int)maxIndex
{
    int leftIndex = (nodeIndex * 2) + 1;
    int rightIndex = (nodeIndex * 2) + 2;

    if (leftIndex < maxIndex)
    {
        NSNumber* leftNode = [array objectAtIndex:leftIndex];
        int swapIndex = leftIndex;
        int swapKey = [leftNode intValue];

        if (rightIndex < maxIndex)
        {
            NSNumber* rightNode = [array objectAtIndex:rightIndex];
            if ([rightNode intValue] > swapKey)
            {
                swapIndex = rightIndex;
                swapKey = [rightNode intValue];
            }
        }

        NSNumber* node = [array objectAtIndex:nodeIndex];
        if ([node intValue] < swapKey)
        {
            [self swapObjectAtIndex:nodeIndex withObjectAtIndex:swapIndex inArray:array];
            [self sinkNodeAtIndex:swapIndex inArray:array toIndex:maxIndex];
        }
    }
}

- (void) swapObjectAtIndex:(int)index1 withObjectAtIndex:(int)index2 inArray:(NSMutableArray*)array
{
    [array exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    NSLog(@"New array order: %@", [self arrayRepresentation:array]);
}

- (NSString*) arrayRepresentation:(NSMutableArray*)array
{
    NSString* string = @"[";

    for (NSNumber* number in array)
    {
        string = [string stringByAppendingFormat:@"%d", [number intValue]];
    }

    return [string stringByAppendingString:@"]"];
}

@end
