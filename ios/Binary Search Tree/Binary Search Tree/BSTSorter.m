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

@end
