//
//  BSTTree.m
//  Binary Search Tree
//
//  Created by Home on 18/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import "BSTTree.h"

@interface BSTTree ()

@property (nonatomic, strong) BSTNode* root;

@end

@implementation BSTTree

- (BSTNode*) find:(int)key
{
    if (self.root)
    {
        return [self.root find:key];
    }
    return nil;
}

- (BOOL) add:(BSTNode*)node
{
    if (self.root)
    {
        return [self.root add:node];
    }
    self.root = node;
    return YES;
}

- (BOOL) remove:(int)key
{
    BSTNode* node = [self find:key];
    if (node)
    {
        if (node == self.root)
        {
            self.root = nil;
        }
        else
        {
            [node removeFromParent];
        }

        [self add:node.left];
        [self add:node.right];
    }
    return NO;
}

- (void) traverse:(TRAVERSAL_COMPLETION)completion
{
    [self.root traverse:completion];
}

@end
