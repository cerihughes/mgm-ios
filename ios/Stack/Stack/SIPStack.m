//
//  SIPStack.m
//  Stack
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import "SIPStack.h"

#import "SIPListElement.h"

@interface SIPStack ()

@property (nonatomic, strong) SIPListElement* head;

@end

@implementation SIPStack

- (BOOL) push:(id)value
{
    self.head = [SIPListElement elementWithNextElement:self.head value:value];
    return YES;
}

- (id) pop
{
    id value = self.head.value;
    self.head = self.head.nextElement;
    return value;
}

@end
