//
//  BSTNode.h
//  Binary Search Tree
//
//  Created by Home on 18/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTNode : NSObject

@property (nonatomic) int key;
@property (nonatomic, strong) id value;

@property (nonatomic, strong) BSTNode* left;
@property (nonatomic, strong) BSTNode* right;

+ (instancetype) nodeWithKey:(int)key;
- (instancetype) initWithKey:(int)key;

- (BSTNode*) find:(int)key;
- (BOOL) add:(BSTNode*)node;
- (BOOL) removeFromParent;

typedef void (^TRAVERSAL_COMPLETION) (BSTNode*);

- (void) traverse:(TRAVERSAL_COMPLETION) completion;

@end
