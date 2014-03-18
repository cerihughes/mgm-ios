//
//  BSTTree.h
//  Binary Search Tree
//
//  Created by Home on 18/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BSTNode.h"

@interface BSTTree : NSObject

- (BSTNode*) find:(int)key;
- (BOOL) add:(BSTNode*)node;
- (BOOL) remove:(int)key;

- (void) traverse:(TRAVERSAL_COMPLETION) completion;

@end
