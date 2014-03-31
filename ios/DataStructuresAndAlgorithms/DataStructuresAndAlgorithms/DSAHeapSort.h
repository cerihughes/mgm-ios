//
//  DSAHeapSort.h
//  DataStructuresAndAlgorithms
//
//  Created by Ceri Hughes on 31/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSAHeapSort : NSObject

- (NSArray*) heapSort:(NSArray*)array;
- (void) inPlaceHeapSort:(NSMutableArray*)array;

@end
