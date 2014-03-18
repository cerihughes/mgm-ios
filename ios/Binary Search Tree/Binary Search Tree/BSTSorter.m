//
//  BSTSorter.m
//  Binary Search Tree
//
//  Created by Home on 18/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import "BSTSorter.h"

#import "BSTNode.h"

@implementation BSTSorter

+ (NSArray*) bubbleSort:(NSArray *)array
{
    NSUInteger count = array.count;
    if (count < 2)
    {
        return array;
    }

    NSMutableArray* mutable = [array mutableCopy];

    for (int i = 1; i < count; i++)
    {
        for (int j = 0; j < count - 1; j++)
        {
            BSTNode* nodeI = [mutable objectAtIndex:i];
            BSTNode* nodeJ = [mutable objectAtIndex:j];

            if (nodeI.key < nodeJ.key)
            {
                [mutable exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }

    return [mutable copy];
}

+ (NSArray*) improvedBubbleSort:(NSArray *)array
{
    NSUInteger count = array.count;
    if (count < 2)
    {
        return array;
    }

    NSMutableArray* mutable = [array mutableCopy];

    for (int i = 1; i < count; i++)
    {
        BOOL changed = NO;
        for (int j = 0; j < count - 1; j++)
        {
            BSTNode* nodeI = [mutable objectAtIndex:i];
            BSTNode* nodeJ = [mutable objectAtIndex:j];

            if (nodeI.key < nodeJ.key)
            {
                [mutable exchangeObjectAtIndex:i withObjectAtIndex:j];
                changed = YES;
            }
        }
        if (!changed)
        {
            return [mutable copy];
        }
    }

    return [mutable copy];
}

+ (NSArray*) mergeSort:(NSArray*)array
{
    NSUInteger count = array.count;
    if (count < 2)
    {
        return array;
    }

    int middle = count / 2;
    NSRange left = NSMakeRange(0, middle);
    NSRange right = NSMakeRange(middle, (count - middle));
    NSArray* rightArray = [array subarrayWithRange:right];
    NSArray* leftArray = [array subarrayWithRange:left];
    return [self merge:[self mergeSort:leftArray] andRight:[self mergeSort:rightArray]];
}

+ (NSArray*) merge:(NSArray*)leftArray andRight:(NSArray*)rightArray
{
    NSLog(@"Merging left and right: [%@][%@]", leftArray, rightArray);
    NSMutableArray *result = [[NSMutableArray alloc]init];
    int right = 0;
    int left = 0;

    while (left < leftArray.count && right < rightArray.count)
    {
        BSTNode* leftNode = [leftArray objectAtIndex:left];
        BSTNode* rightNode = [rightArray objectAtIndex:right];
        if (leftNode.key < rightNode.key)
        {
            [result addObject:leftNode];
            left++;
        }
        else
        {
            [result addObject:rightNode];
            right++;
        }
    }

    NSRange leftRange = NSMakeRange(left, (leftArray.count - left));
    NSRange rightRange = NSMakeRange(right, (rightArray.count - right));
    NSArray* newRight = [rightArray subarrayWithRange:rightRange];
    NSArray* newLeft = [leftArray subarrayWithRange:leftRange];
    
    newLeft = [result arrayByAddingObjectsFromArray:newLeft];
    return [newLeft arrayByAddingObjectsFromArray:newRight];
}

@end
