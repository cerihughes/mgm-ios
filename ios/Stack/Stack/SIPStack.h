//
//  SIPStack.h
//  Stack
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIPStack : NSObject

- (BOOL) push:(id)value;
- (id) pop;

@end
