//
//  DSAQuickSort.m
//  DataStructuresAndAlgorithms
//
//  Created by Home on 01/04/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "DSAQuickSort.h"

@implementation DSAQuickSort

- (NSArray*) quickSort:(NSArray*)array
{
    NSMutableArray* finalArray = [NSMutableArray array];

    NSMutableArray* leftArray = [NSMutableArray array];
    NSMutableArray* rightArray = [NSMutableArray array];
    NSNumber* middleNode = [self partitionArray:array intoLeftArray:leftArray rightArray:rightArray];

    if (middleNode)
    {
        [finalArray addObjectsFromArray:[self quickSort:leftArray]];
        [finalArray addObject:middleNode];
        [finalArray addObjectsFromArray:[self quickSort:rightArray]];
    }

    return [finalArray copy];
}

- (NSNumber*) partitionArray:(NSArray*)array intoLeftArray:(NSMutableArray*)leftArray rightArray:(NSMutableArray*)rightArray
{
    NSUInteger count = [array count];
    if (count == 0)
    {
        return nil;
    }
    else
    {
        NSNumber* firstNode = array[0];
        for (int i = 1; i < count; i++)
        {
            NSNumber* nextNode = array[i];
            if ([firstNode intValue] > [nextNode intValue])
            {
                [leftArray addObject:nextNode];
            }
            else
            {
                [rightArray addObject:nextNode];
            }
        }
        return firstNode;
    }
}

@end
