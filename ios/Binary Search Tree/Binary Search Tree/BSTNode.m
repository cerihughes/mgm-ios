//
//  BSTNode.m
//  Binary Search Tree
//
//  Created by Home on 18/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import "BSTNode.h"

@interface BSTNode ()

@property (nonatomic, strong) BSTNode* parent;

@end

@implementation BSTNode

+ (instancetype) nodeWithKey:(int)key
{
    return [[BSTNode alloc] initWithKey:key];
}

- (instancetype) initWithKey:(int)key
{
    self = [super init];
    if (self)
    {
        _key = key;
    }
    return self;
}

- (BSTNode*) find:(int)key
{
    if (key == self.key)
    {
        return self;
    }
    else if (key < self.key)
    {
        return [self.left find:key];
    }
    else
    {
        return [self.right find:key];
    }
}

- (BOOL) add:(BSTNode *)node
{
    int key = node.key;
    if (key == self.key)
    {
        return NO;
    }
    else if (key < self.key)
    {
        if (self.left)
        {
            return [self.left add:node];
        }
        else
        {
            self.left = node;
        }
    }
    else
    {
        if (self.right)
        {
            return [self.right add:node];
        }
        else
        {
            self.right = node;
        }
    }

    node.parent = self;
    return YES;
}

- (BOOL) removeChild:(BSTNode*)node
{
    if (self.left == node)
    {
        self.left = nil;
    }
    else if (self.right == node)
    {
        self.right = nil;
    }
    else
    {
        return NO;
    }
    return YES;
}

- (BSTNode*) rightmostNode
{
    if (self.right)
    {
        return [self.right rightmostNode];
    }
    return self;
}

- (BOOL) removeFromParent
{
    if (self.parent)
    {
        if (!(self.left || self.right))
        {
            [self.parent removeChild:self];
        }
        else if (self.left)
        {
            [self.parent removeChild:self];
            [self.parent add:self.left];
        }
        else if (self.right)
        {
            [self.parent removeChild:self];
            [self.parent add:self.right];
        }
        else
        {

        }
    }
    return YES;
}

- (void) traverse:(TRAVERSAL_COMPLETION)completion
{
    [self.left traverse:completion];

    completion(self);

    [self.right traverse:completion];
}

@end
