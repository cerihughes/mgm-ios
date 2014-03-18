//
//  main.m
//  Binary Search Tree
//
//  Created by Home on 18/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import "BSTTree.h"
#import "BSTSorter.h"

void bubbleSort()
{
    NSArray* array = @[[BSTNode nodeWithKey:1], [BSTNode nodeWithKey:8], [BSTNode nodeWithKey:6], [BSTNode nodeWithKey:4], [BSTNode nodeWithKey:2], [BSTNode nodeWithKey:9], [BSTNode nodeWithKey:7], [BSTNode nodeWithKey:5], [BSTNode nodeWithKey:3], [BSTNode nodeWithKey:10]];

    NSLog(@"Pre sort:%@", array);

    array = [BSTSorter improvedBubbleSort:array];

    NSLog(@"Post sort:%@", array);
}

void treeTest()
{
    BSTTree* tree = [[BSTTree alloc] init];

    [tree add:[BSTNode nodeWithKey:10]];
    [tree add:[BSTNode nodeWithKey:8]];
    [tree add:[BSTNode nodeWithKey:6]];
    [tree add:[BSTNode nodeWithKey:4]];
    [tree add:[BSTNode nodeWithKey:2]];
    [tree add:[BSTNode nodeWithKey:9]];
    [tree add:[BSTNode nodeWithKey:7]];
    [tree add:[BSTNode nodeWithKey:5]];
    [tree add:[BSTNode nodeWithKey:3]];
    [tree add:[BSTNode nodeWithKey:1]];

    NSLog(@"Full Tree");
    [tree traverse:^(BSTNode* node) {
        NSLog(@"%d", node.key);
    }];

    NSLog(@"Remove a node with 2 children");
    [tree remove:6];
    [tree traverse:^(BSTNode* node) {
        NSLog(@"%d", node.key);
    }];

    NSLog(@"Remove a leaf");
    [tree remove:1];
    [tree traverse:^(BSTNode* node) {
        NSLog(@"%d", node.key);
    }];

    NSLog(@"Remove the root");
    [tree remove:10];
    [tree traverse:^(BSTNode* node) {
        NSLog(@"%d", node.key);
    }];
}

int main(int argc, char * argv[])
{
    bubbleSort();
}
